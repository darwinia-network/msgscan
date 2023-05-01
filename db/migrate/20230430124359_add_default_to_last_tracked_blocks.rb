class AddDefaultToLastTrackedBlocks < ActiveRecord::Migration[7.0]
  def change
    change_column_default :last_tracked_blocks, :last_tracked_block, 0
  end
end
