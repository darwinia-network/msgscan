class CreateLastTrackedBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :last_tracked_blocks do |t|
      t.integer :chain_id
      t.integer :last_tracked_block

      t.timestamps
    end
  end
end
