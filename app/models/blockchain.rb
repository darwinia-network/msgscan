include Eth

class Blockchain < ApplicationRecord
  has_many :channels_from_it, class_name: 'Channel', foreign_key: 'src_blockchain_id'
  has_many :channels_to_it, class_name: 'Channel', foreign_key: 'dst_blockchain_id'

  def rpc_client
    raise 'rpc is not set' if rpc.nil?

    Eth::Client::Http.new(rpc)
  end

  def latest_block_number
    rpc_client.eth_block_number['result'].to_i(16) - 12
  end
end
