class RenameColumnsOfChannels < ActiveRecord::Migration[7.0]
  def change
    rename_column :channels, :outbound_lane, :from_outbound_lane
    rename_column :channels, :inbound_lane, :to_inbound_lane
  end
end
