class CreateCrossChainMessageEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :cross_chain_message_events do |t|
      t.integer :cross_chain_message_id
      t.integer :event_id

      t.timestamps
    end
  end
end
