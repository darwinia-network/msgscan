class EvmLcmpLane < ApplicationRecord
  validates :outbound_lane_address, uniqueness: { scope: :src_blockchain_id }
  validates :inbound_lane_address, uniqueness: { scope: :dst_blockchain_id }

  has_one :channel, as: :channelable
end
