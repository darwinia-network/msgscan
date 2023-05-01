require 'eth'
include Eth

require_relative '../evm/evm_track_helper'
require_relative '../abi/events_abi'
require_relative '../utils'
require_relative '../evm/scan_logs'
require_relative '../../config/environment'

def scan_logs_loop(blockchain, contracts, abi)
  loop do
    from, to = blockchain.last_tracked_block.reload.get_next_block_range
    if from >= to
      puts 'no new blocks, sleep 30s'
      sleep 30
      next
    end
    p "scan logs from block: #{from}, to block: #{to}"

    scan_logs(blockchain.rpc, from, to, contracts, abi) do |log|
      # p log
      log['blockchain_id'] = blockchain.id
      EvmLcmpLog.create!(log) unless EvmLcmpLog.exists?(log)
    end

    blockchain.set_last_tracked_block(to)
  rescue StandardError => e
    puts e
    puts e.backtrace
    sleep 30
  end
end

abi = EventsAbi.new('./lib/abi/lane-events.json')

contracts = %w[
  0xabd165de531d26c229f9e43747a8d683ead54c6c
  0xb59a893f5115c1ca737e36365302550074c32023
]

pangolin = Blockchain.find_by_name('pangolin')

scan_logs_loop(pangolin, contracts, abi)
