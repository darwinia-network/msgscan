class EvmLcmpLane < ApplicationRecord
  validates :outbound_lane_address, uniqueness: { scope: :src_blockchain_id }
  validates :inbound_lane_address, uniqueness: { scope: :dst_blockchain_id }

  has_one :channel, as: :channelable

  def self.get_channel(blockchain_id, address)
    lane = find_by(
      src_blockchain_id: blockchain_id,
      outbound_lane_address: address
    )

    return lane.channel if lane

    lane = find_by(
      dst_blockchain_id: blockchain_id,
      inbound_lane_address: address
    )

    return lane.channel if lane
  end
end
