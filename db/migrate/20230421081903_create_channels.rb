class CreateChannels < ActiveRecord::Migration[7.0]
  def change
    create_table :channels do |t|
      t.integer :from_chain_id
      t.integer :to_chain_id
      t.string :outbound_lane
      t.string :inbound_lane

      t.timestamps
    end
  end
end
