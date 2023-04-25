include Eth

class Blockchain < ApplicationRecord
  has_many :channels_from_it, class_name: 'Channel', foreign_key: 'from_blockchain_id'
  has_many :channels_to_it, class_name: 'Channel', foreign_key: 'to_blockchain_id'

  def channel_from_it(address)
    channels_from_it.find do |channel|
      channel.outbound_lane.downcase == address.downcase
    end
  end

  def channel_to_it(address)
    channels_to_it.find do |channel|
      channel.inbound_lane.downcase == address.downcase
    end
  end

  def outbound_lanes
    channels_from_it.map(&:outbound_lane)
  end

  def inbound_lanes
    channels_to_it.map(&:inbound_lane)
  end

  def rpc_client
    raise 'rpc is not set' if rpc.nil?

    Eth::Client::Http.new(rpc)
  end

  def latest_block_number
    rpc_client.eth_block_number['result'].to_i(16) - 12
  end
end
