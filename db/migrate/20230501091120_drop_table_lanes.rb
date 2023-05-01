class DropTableLanes < ActiveRecord::Migration[7.0]
  def change
    drop_table :lanes
  end
end
