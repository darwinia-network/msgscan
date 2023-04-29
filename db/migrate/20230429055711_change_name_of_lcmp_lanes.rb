class ChangeNameOfLcmpLanes < ActiveRecord::Migration[7.0]
  def change
    rename_table :lcmp_lanes, :evm_lcmp_lanes
  end
end
