require 'eth'
include Eth

require_relative '../evm/evm_track_helper'
require_relative '../abi/events_abi'
require_relative '../utils'
require_relative '../evm/scan_logs'
require_relative '../../config/environment'

abi = EventsAbi.new('./lib/abi/lane-events.json')

contracts = %w[
  0x9B5010d562dDF969fbb85bC72222919B699b5F54
  0x0F6e081B1054c59559Cf162e82503F3f560cA4AF
]
goerli_blockchain_id = 1 # goerli
pangolin_blockchain_id = 2 # pangolin
channel_g_p = Channel.find(1)
channel_p_g = Channel.find(2)

scan_logs(
  'https://eth-goerli.g.alchemy.com/v2/hYlUsCk2XySXBkX_VHd5drH73YWQEfgy',
  0,
  8_900_814,
  contracts,
  abi
) do |log|
  begin
    log['blockchain_id'] = goerli_blockchain_id
    log['counterpart_blockchain_id'] = pangolin_blockchain_id
    case log['event_name']
    when 'MessageAccepted'
      log['direction'] = EvmLcmpLog.directions[:out]
    when 'MessageDispatched'
      log['direction'] = EvmLcmpLog.directions[:in]
    when 'DappErrCatched'
      log['direction'] = EvmLcmpLog.directions[:in]
    when 'DappErrCatchedBytes'
      log['direction'] = EvmLcmpLog.directions[:in]
    when 'MessageDelivered'
      log['direction'] = EvmLcmpLog.directions[:out]
    end
    p log
    EvmLog.create log
  rescue StandardError => e
    puts e
    puts e.backtrace
  end

  exit
end
