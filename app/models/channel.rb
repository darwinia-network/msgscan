require_relative '../../lib/utils'

class Channel < ApplicationRecord
  belongs_to :src_blockchain, class_name: 'Blockchain', foreign_key: 'src_blockchain_id'
  belongs_to :dst_blockchain, class_name: 'Blockchain', foreign_key: 'dst_blockchain_id'

  belongs_to :channelable, polymorphic: true

  def name
    "#{src_blockchain.name} > #{dst_blockchain.name}"
  end

  def get_peer_blockchain_id(blockchain_id)
    if src_blockchain_id == blockchain_id
      dst_blockchain_id
    elsif dst_blockchain_id == blockchain_id
      src_blockchain_id
    end
  end
end
