require_relative '../evm/evm_track_helper'
Rails.logger = Logger.new($stdout)
require_relative '../abi/events_abi'
require_relative '../utils'

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
      LastTrackedBlock.set_last_tracked_block(blockchain_id, to_block)
    end
  end
end
