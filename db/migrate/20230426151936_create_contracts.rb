class CreateContracts < ActiveRecord::Migration[7.0]
  def change
    create_table :contracts do |t|
      t.string :address
      t.string :name
      t.integer :lane_id
      t.integer :blockchain_id
      t.json :events_interface

      t.timestamps
    end
  end
end
