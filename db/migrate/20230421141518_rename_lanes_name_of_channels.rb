class RenameLanesNameOfChannels < ActiveRecord::Migration[7.0]
  def change
    rename_column :channels, :from_outbound_lane, :outbound_lane
    rename_column :channels, :to_inbound_lane, :inbound_lane
  end
end
