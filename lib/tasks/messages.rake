require_relative '../evm_track_helper'
Rails.logger = Logger.new($stdout)

namespace :messages do
  desc 'scan messaging events between a range of a chain'
  task :scan_messaging_events_between, %i[chain_id from_block to_block] => :environment do |_, args|
    chain_id = args.chain_id.to_i
    from_block = args.from_block.to_i
    to_block = args.to_block.to_i # 8_866_987

    chain = Blockchain.find_by_id(chain_id)
    abort "blockchain #{args.chain_id} not exist" if chain.nil?

    abort 'run too far' if from_block >= to_block
    latest_block_number = EvmTrackHelper.new(chain.rpc).get_latest_block_number
    to_block = [latest_block_number, to_block].min

    scan_messaging_events_between(chain, from_block, to_block)
  end

  desc 'scan messaging events of a chain'
  task :scan_messaging_events_of, %i[chain_id blocks_to_scan] => :environment do |_, args|
    timed do
      blockchain_id = args.chain_id.to_i
      chain = Blockchain.find_by_id(blockchain_id)
      abort "blockchain #{blockchain_id} not exist" if chain.nil?

      # calculate from_block
      from_block = LastTrackedBlock.get_last_tracked_block(blockchain_id) + 1

      # calculate to_block
      latest_block_number = EvmTrackHelper.new(chain.rpc).get_latest_block_number
      to_block =
        if args.blocks_to_scan&.to_i&.positive?
          [latest_block_number, from_block + args.blocks_to_scan.to_i - 1].min
        else
          latest_block_number
        end

      abort 'run too far' if from_block >= to_block

      scan_messaging_events_between(chain, from_block, to_block)

      # update last tracked block
      # LastTrackedBlock.set_last_tracked_block(blockchain_id, to_block)
    end
  end
end

def scan_messaging_events_between(chain, from_block, to_block)
  helper = EvmTrackHelper.new(chain.rpc)
  Rails.logger.info "[track] events of #{chain.name} from block: #{from_block} to block: #{to_block}."

  # contracts to track
  contracts = chain.outbound_lanes + chain.inbound_lanes + ['0x2174b56E451FCf324a948332f72D217e16B9f531']

  # topics to track
  abi = MessagingAbi.new('./lib/abi/lane-events.json')
  topics = abi.event_topics
  puts topics

  # log fields:
  # [
  #  "address", "blockHash", "blockNumber", "data", "logIndex",
  #  "removed", "topics", "transactionHash", "transactionIndex"
  # ]
  helper.get_logs(contracts, [topics], from_block, to_block).each do |log|
    # convert hex to decimal
    log['blockNumber'] = log['blockNumber'].to_i(16)
    log['logIndex'] = log['logIndex'].to_i(16)
    # add timestamp to log
    block = helper.get_block_by_number(log['blockNumber'])
    log['timestamp'] = block['timestamp'].to_i(16)

    process_events(abi, log) do |address, event_name, data|
      message =
        case event_name
        when 'MessageAccepted'
          channel = chain.channel_from_it(address)
          raise "channel from #{chain.name}(id: #{chain.id}) not found for address: #{address}" if channel.nil?

          { channel_id: channel.id }.merge(data)
        when 'MessageDispatched'
          channel = chain.channel_to_it(address)
          raise "channel to #{chain.name}(id: #{chain.id}) not found for address: #{address}" if channel.nil?

          { channel_id: channel.id }.merge(data) if channel
        when 'FailedMessage'
          puts '----------------------------------------------------------------'
          puts data
          channel = chain.channel_to_it(address)
          raise "channel to #{chain.name}(id: #{chain.id}) not found for address: #{address}" if channel.nil?

          { channel_id: channel.id }.merge(data) if channel
        when 'MessagesDelivered'
          channel = chain.channel_from_it(address)
          raise "channel from #{chain.name}(id: #{chain.id}) not found for address: #{address}" if channel.nil?

          { channel_id: channel.id }.merge(data)
        else
          raise "unknown event name: #{event_name}"
        end

      # Message.upsert(message, unique_by: %i[channel_id nonce])
    end
  end
end

# 1. Ethereum
#     contract: `Outboundlane`
#     event: `event MessageAccepted(uint64 indexed nonce, address source, address target, bytes encoded);`
# 2. Darwinia
#     contract: `Inboundlane`
#     event: `event MessageDispatched(uint64 nonce, bool result);`
# 3. Darwinia: FailedMessage
# 3. Ethereum
#     contract: `Outboundlane`
#     event: `event MessagesDelivered(uint64 indexed begin, uint64 indexed end);`
def process_events(abi, log)
  timestamp = log['timestamp']
  tx_hash = log['transactionHash']
  case log['topics'][0]
  when abi.accepted_event_topic
    event_name = abi.accepted_event_interface['name']
    Rails.logger.info "[track] #{event_name}"

    _, args =
      Abi::Event.decode_log(
        abi.accepted_event_interface['inputs'],
        log['data'],
        log['topics']
      )
    message = {
      nonce: args[:nonce],
      block_number: log['blockNumber'],
      accepted_at: Time.at(timestamp),
      accepted_tx: tx_hash,
      from_dapp: args[:source],
      to_dapp: args[:target],
      payload: args[:encoded].bytes.to_hex
    }
    yield log['address'], event_name, message
  when abi.dispatched_event_topic
    event_name = abi.dispatched_event_interface['name']
    Rails.logger.info "[track] #{event_name}"

    _, args =
      Abi::Event.decode_log(
        abi.dispatched_event_interface['inputs'],
        log['data'],
        log['topics']
      )
    message = {
      nonce: args[:nonce],
      dispatched_at: Time.at(timestamp),
      dispatched_tx: tx_hash
    }
    yield(log['address'], event_name, message)
  when abi.failed_message_event_topic
    event_name = abi.failed_message_event_interface['name']
    Rails.logger.info "[track] #{event_name}"

    _, args =
      Abi::Event.decode_log(
        abi.failed_message_event_interface['inputs'],
        log['data'],
        log['topics']
      )
    message = {
      nonce: args[:nonce],
      dispatch_error: args[:reason],
      data: args[:message]
    }
    yield(log['address'], event_name, message)
  when abi.delivered_event_topic
    event_name = abi.delivered_event_interface['name']
    Rails.logger.info "[track] #{event_name}"

    _, args =
      Abi::Event.decode_log(
        abi.delivered_event_interface['inputs'],
        log['data'],
        log['topics']
      )
    (args[:begin]..args[:end]).each do |nonce|
      message = {
        nonce:,
        delivered_at: Time.at(timestamp),
        delivered_tx: tx_hash
      }
      yield(log['address'], event_name, message)
    end
  end
end

def timed
  b = Time.now
  yield
  e = Time.now
  Rails.logger.debug "#{e - b}s"
end

class MessagingAbi
  def initialize(abi_file_path)
    @abi = JSON.parse File.read(abi_file_path)
    @accepted_event_interface = find_event_interface 'MessageAccepted'
    @dispatched_event_interface = find_event_interface 'MessageDispatched'
    @failed_message_event_interface = find_event_interface 'FailedMessage'
    @delivered_event_interface = find_event_interface 'MessagesDelivered'

    if @accepted_event_interface.nil? || @dispatched_event_interface.nil? || @delivered_event_interface.nil?
      raise 'invalid abi file'
    end

    @accepted_event_topic = Abi::Event.compute_topic(@accepted_event_interface)
    @dispatched_event_topic = Abi::Event.compute_topic(@dispatched_event_interface)
    @failed_message_event_topic = Abi::Event.compute_topic(@failed_message_event_interface)
    @delivered_event_topic = Abi::Event.compute_topic(@delivered_event_interface)
  end

  attr_reader :accepted_event_interface, :dispatched_event_interface, :failed_message_event_interface, :delivered_event_interface,
              :accepted_event_topic, :dispatched_event_topic, :failed_message_event_topic, :delivered_event_topic

  def event_topics
    [@accepted_event_topic, @dispatched_event_topic, @failed_message_event_topic, @delivered_event_topic]
  end

  private

  def find_event_interface(event_name)
    @abi.find { |i| i['type'] == 'event' && i['name'] == event_name }
  end
end
