class CreateLcmpLanes < ActiveRecord::Migration[7.0]
  def change
    create_table :lcmp_lanes do |t|
      t.integer :src_blockchain_id
      t.string :oubound_lane_address
      t.integer :dst_blockchain_id
      t.string :inbound_lane_address

      t.timestamps
    end
  end
end
