require_relative './preprocess_log'

def scan_logs(chain_rpc, from_block, to_block, contracts, abi)
  helper = EvmTrackHelper.new(chain_rpc)
  helper.get_logs(contracts, [abi.topics], from_block, to_block).each do |log|
    # TODO: add log to task queue
    yield preprocess_log(helper, abi, log)
  end
end

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
