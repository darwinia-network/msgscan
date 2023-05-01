# {"address"=>"0x9b5010d562ddf969fbb85bc72222919b699b5f54", "block_hash"=>"0xa95517437993cf456b97320bbcfa861af453fe961d90bace7a27866050e3f5b7", "block_number"=>8861222, "data"=>"0x0000000000000000000000000085a7739de16716b5dd5a07d42d08708769c988000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000000", "log_index"=>2, "removed"=>false, "topics"=>["0x98c95af5732ea9f6898d677074a303d37cbf80a533c81aafef61e3414624624e", "0x0000000000000000000000000000000000000000000000000000000000000001"], "transaction_hash"=>"0x14f429d964930c0cd21866ba0aee99e77f3ae4d67d50e32b0ebc0fdfe132ca36", "transaction_index"=>"0x5", "timestamp"=>1681996152, "event_name"=>"MessageAccepted", "args"=>{:nonce=>1, :source=>"0x0085a7739de16716b5dd5a07d42d08708769c988", :target=>"0x0000000000000000000000000000000000000000", :encoded=>""}}
def preprocess_log(helper, abi, log)
  log['blockNumber'] = log['blockNumber'].to_i(16)
  log['logIndex'] = log['logIndex'].to_i(16)
  log['transactionIndex'] = log['transactionIndex'].to_i(16)

  # get timestamp from block
  block = helper.get_block_by_number(log['blockNumber'])
  log['log_at'] = Time.at block['timestamp'].to_i(16)

  # decode log data
  intf = get_interface(log, abi)
  return if intf.nil?

  log['eventName'] = intf['name']

  _, log['args'] =
    Abi::Event.decode_log(
      intf['inputs'],
      log['data'],
      log['topics']
    )

  # convert binary to hex
  log['args'].each do |k, v|
    log['args'][k] = Util.bin_to_hex(v) if v.instance_of?(String) && v.encoding == Encoding::ASCII_8BIT
  end

  # unify keys
  log['args'].transform_keys!(&:to_s)

  # convert keys to snake case
  log.transform_keys! do |k|
    snake_case(k)
  end

  # remove transaction_log_index, darwinia chain doesn't have this field
  log.delete('transaction_log_index')

  log
end

def get_interface(log, abi)
  case log['topics'][0]
  when abi.topic('MessageAccepted')
    abi['MessageAccepted']
  when abi.topic('MessageDispatched')
    abi['MessageDispatched']
  when abi.topic('DappErrCatched')
    abi['DappErrCatched']
  when abi.topic('DappErrCatchedBytes')
    abi['DappErrCatchedBytes']
  when abi.topic('MessagesDelivered')
    abi['MessagesDelivered']
  end
end

# process_events(abi, log) do |address, event_name, data|
#   message =
#     case event_name
#     when 'MessageAccepted'
#       channel = chain.channel_from_it(address)
#       raise "channel from #{chain.name}(id: #{chain.id}) not found for address: #{address}" if channel.nil?

#       { channel_id: channel.id }.merge(data)
#     when 'MessageDispatched'
#       channel = chain.channel_to_it(address)
#       raise "channel to #{chain.name}(id: #{chain.id}) not found for address: #{address}" if channel.nil?

#       { channel_id: channel.id }.merge(data) if channel
#     when 'FailedMessage'
#       puts '----------------------------------------------------------------'
#       puts data
#       channel = chain.channel_to_it(address)
#       raise "channel to #{chain.name}(id: #{chain.id}) not found for address: #{address}" if channel.nil?

#       { channel_id: channel.id }.merge(data) if channel
#     when 'MessagesDelivered'
#       channel = chain.channel_from_it(address)
#       raise "channel from #{chain.name}(id: #{chain.id}) not found for address: #{address}" if channel.nil?

#       { channel_id: channel.id }.merge(data)
#     else
#       raise "unknown event name: #{event_name}"
#     end

#   # Message.upsert(message, unique_by: %i[channel_id nonce])
# end
