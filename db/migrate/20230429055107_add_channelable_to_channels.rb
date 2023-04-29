class AddChannelableToChannels < ActiveRecord::Migration[7.0]
  def change
    add_column :channels, :channelable_id, :integer
    add_column :channels, :channelable_type, :string
  end
end
