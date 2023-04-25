class AddIndexToLastTrackedBlocks < ActiveRecord::Migration[7.0]
  def change
    add_index :last_tracked_blocks, :chain_id, unique: true
  end
end
