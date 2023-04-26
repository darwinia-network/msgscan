class Channel < ApplicationRecord
  validates :outbound_lane, uniqueness: { scope: :from_blockchain_id }
  validates :inbound_lane, uniqueness: { scope: :to_blockchain_id }

  belongs_to :from_blockchain, class_name: 'Blockchain', foreign_key: 'from_blockchain_id'
  belongs_to :to_blockchain, class_name: 'Blockchain', foreign_key: 'to_blockchain_id'

  def direction
    "#{from_blockchain.name} > #{to_blockchain.name}"
  end
end
