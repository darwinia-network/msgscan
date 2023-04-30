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

goerli = Blockchain.find_by_name('goerli')
pangolin_blockchain_id = 2 # pangolin
channel_g_p = goerli.channels_from_it.first
channel_p_g = goerli.channels_to_it.first

scan_logs(
  'https://eth-goerli.g.alchemy.com/v2/hYlUsCk2XySXBkX_VHd5drH73YWQEfgy',
  0,
  8_900_814,
  contracts,
  abi
) do |log|
  log['blockchain_id'] = goerli.id
  # check if log exists
  # if yes, update. if no, insert
  existed_log =
    EvmLcmpLog.find_by blockchain_id: log['blockchain_id'],
                       block_number: log['block_number'],
                       transaction_index: log['transaction_index'],
                       log_index: log['log_index']
  puts existed_log
  EvmLcmpLog.create! log unless existed_log
end
