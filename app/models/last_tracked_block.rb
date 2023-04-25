class LastTrackedBlock < ApplicationRecord
  validates :blockchain_id, uniqueness: true
  belongs_to :blockchain

  def self.get_last_tracked_block(blockchain_id)
    last_tracked_block = LastTrackedBlock.find_by(blockchain_id:).try(:last_tracked_block)
    last_tracked_block || 0
  end

  def self.set_last_tracked_block(blockchain_id, number)
    LastTrackedBlock.upsert({ blockchain_id:, last_tracked_block: number }, unique_by: :blockchain_id)
  end

  def self.update_to_latest(blockchain_id, offset = 0)
    set_last_tracked_block(blockchain_id, blockchain.latest_block_number - offset)
  end
end
