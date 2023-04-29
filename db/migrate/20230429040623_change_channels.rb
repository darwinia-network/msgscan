class ChangeChannels < ActiveRecord::Migration[7.0]
  def change
    remove_column :channels, :outbound_lane, :string
    remove_column :channels, :inbound_lane, :string
    rename_column :channels, :from_blockchain_id, :src_blockchain_id
    rename_column :channels, :to_blockchain_id, :dst_blockchain_id
    add_column :channels, :channelable_id, :integer
    add_column :channels, :channelable_type, :string
  end
end
