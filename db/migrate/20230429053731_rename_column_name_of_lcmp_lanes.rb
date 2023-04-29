class RenameColumnNameOfLcmpLanes < ActiveRecord::Migration[7.0]
  def change
    rename_column :lcmp_lanes, :oubound_lane_address, :outbound_lane_address
  end
end
