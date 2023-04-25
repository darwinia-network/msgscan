class Channel < ApplicationRecord
  validates :outbound_lane, uniqueness: { scope: :from_blockchain_id }
  validates :inbound_lane, uniqueness: { scope: :to_blockchain_id }
end
