class EvmLcmpLog < ApplicationRecord
  belongs_to :blockchain
  has_one :event, as: :event_source

  after_create :process_log

  def self.exists?(log)
    EvmLcmpLog.find_by(
      {
        blockchain_id: log['blockchain_id'],
        block_number: log['block_number'],
        transaction_index: log['transaction_index'],
        log_index: log['log_index']
      }
    ).present?
  end

  def process_log
    # channel config for this log
    channel = EvmLcmpLane.get_channel(blockchain_id, address)
    raise "Channel not found for #{blockchain_id} #{address}" unless channel

    # create event for this log
    event = Event.create! event_source_type: 'EvmLcmpLog', event_source_id: id

    # do process log, create or update the related cross chain message
    case event_name
    when 'MessageAccepted'
      puts 'MessageAccepted'
      process_message_accepted(channel, event)
    when 'MessageDispatched'
      puts 'MessageDispatched'
      process_message_dispatched(channel, event)
    when 'DappErrCatched'
      puts 'DappErrCatched'
      process_dapp_err_catched(channel, event)
    when 'DappErrCatchedBytes'
      puts 'DappErrCatchedBytes'
      process_dapp_err_catched_bytes(channel, event)
    when 'MessagesDelivered'
      puts 'MessagesDelivered'
      process_messages_delivered(channel, event)
    end
  end

  def process_message_accepted(channel, event)
    result = CrossChainMessage.upsert(
      {
        src_blockchain_id: blockchain_id,
        dst_blockchain_id: channel.get_peer_blockchain_id(blockchain_id),
        channel_id: channel.id,
        nonce: args['nonce'],
        sent_at: log_at,
        src_transaction_hash: transaction_hash,
        sent_at_event_id: event.id,
        from_dapp: args['source'],
        to_dapp: args['target'],
        payload: args['encoded'] # TODO: decode the real message
      },
      unique_by: %i[src_blockchain_id dst_blockchain_id channel_id nonce]
    )

    message = CrossChainMessage.find(result.first['id'])
    CrossChainMessageEvent.create(cross_chain_message_id: message.id, event_id: event.id)

    message.broadcast_to_frontend
  end

  def process_message_dispatched(channel, event)
    result = CrossChainMessage.upsert(
      {
        src_blockchain_id: channel.get_peer_blockchain_id(blockchain_id),
        dst_blockchain_id: blockchain_id,
        channel_id: channel.id,
        nonce: args['nonce'],
        executed_at: log_at,
        executed_at_event_id: event.id,
        dst_transaction_hash: transaction_hash
      },
      unique_by: %i[src_blockchain_id dst_blockchain_id channel_id nonce]
    )

    CrossChainMessageEvent.create(cross_chain_message_id: result.first['id'], event_id: event.id)
  end

  def process_dapp_err_catched(channel, event)
    dispatched_log = EvmLcmpLog.find_by(event_name: 'MessageDispatched', transaction_hash:)
    return unless dispatched_log

    result = CrossChainMessage.upsert(
      {
        src_blockchain_id: channel.get_peer_blockchain_id(blockchain_id),
        dst_blockchain_id: blockchain_id,
        channel_id: channel.id,
        nonce: dispatched_log.args['nonce'],
        execution_error: args['_reason'],
        execution_error_event_id: event.id
      },
      unique_by: %i[src_blockchain_id dst_blockchain_id channel_id nonce]
    )

    CrossChainMessageEvent.create(cross_chain_message_id: result.first['id'], event_id: event.id)
  end

  def process_dapp_err_catched_bytes(channel, event)
    dispatched_log = EvmLcmpLog.find_by(event_name: 'MessageDispatched', transaction_hash:)
    return unless dispatched_log

    # convert binary reason to hex
    reason = args['_reason']
    reason = Util.bin_to_hex(reason) if reason.instance_of?(String) && reason.encoding == Encoding::ASCII_8BIT

    result = CrossChainMessage.upsert(
      {
        src_blockchain_id: channel.get_peer_blockchain_id(blockchain_id),
        dst_blockchain_id: blockchain_id,
        channel_id: channel.id,
        nonce: dispatched_log.args['nonce'],
        execution_error: reason,
        execution_error_event_id: event.id
      },
      unique_by: %i[src_blockchain_id dst_blockchain_id channel_id nonce]
    )

    CrossChainMessageEvent.create(cross_chain_message_id: result.first['id'], event_id: event.id)
  end

  def process_messages_delivered(channel, event)
    nonce_begin = args['begin']
    nonce_end = args['end']

    peer_blockchain_id = channel.get_peer_blockchain_id(blockchain_id)
    (nonce_begin..nonce_end).each do |nonce|
      result = CrossChainMessage.upsert(
        {
          src_blockchain_id: blockchain_id,
          dst_blockchain_id: peer_blockchain_id,
          channel_id: channel.id,
          nonce:,
          confirmed_at: log_at,
          confirmed_at_event_id: event.id
        },
        unique_by: %i[src_blockchain_id dst_blockchain_id channel_id nonce]
      )

      CrossChainMessageEvent.create(cross_chain_message_id: result.first['id'], event_id: event.id)
    end
  end
end
