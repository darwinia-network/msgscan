class Channel < ApplicationRecord
  belongs_to :src_blockchain, class_name: 'Blockchain', foreign_key: 'src_blockchain_id'
  belongs_to :dst_blockchain, class_name: 'Blockchain', foreign_key: 'dst_blockchain_id'

  belongs_to :channelable, polymorphic: true

  def channel_name
    "##{id}-#{channelable_type}-#{src_blockchain.name}-#{dst_blockchain.name}"
  end
end
