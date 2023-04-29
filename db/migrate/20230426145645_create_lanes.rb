class CreateLanes < ActiveRecord::Migration[7.0]
  def change
    create_table :lanes do |t|
      t.integer :src_blockchain_id
      t.integer :dst_blockchain_id

      t.timestamps
    end
  end
end
