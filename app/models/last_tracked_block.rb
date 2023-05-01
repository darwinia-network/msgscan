class LastTrackedBlock < ApplicationRecord
  validates :blockchain_id, uniqueness: true
  belongs_to :blockchain

  def self.set_last_tracked_block(blockchain_id, number)
    LastTrackedBlock.upsert({ blockchain_id:, last_tracked_block: number }, unique_by: :blockchain_id)
  end

  def self.update_to_latest(blockchain_id, offset = 0)
    set_last_tracked_block(blockchain_id, blockchain.latest_block_number - offset)
  end

  def get_next_block_range
    blockchain = Blockchain.find_by_id(blockchain_id)

    # calculate from_block
    from_block = last_tracked_block + 1

    # calculate to_block
    latest_block_number = blockchain.latest_block_number
    to_block =
      if blockchain.blocks_per_scan&.positive?
        [latest_block_number, from_block + blockchain.blocks_per_scan - 1].min
      else
        latest_block_number
      end

    [from_block, to_block]
  end
end
