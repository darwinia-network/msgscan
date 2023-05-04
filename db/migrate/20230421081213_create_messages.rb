class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :channel_id
      t.integer :nonce
      t.integer :status
      t.timestamp :accepted_at
      t.string :accepted_tx
      t.timestamp :dispatched_at
      t.string :dispatch_error
      t.string :dispatched_tx
      t.timestamp :delivered_at
      t.string :delivered_tx
      t.string :from_dapp
      t.string :to_dapp
      t.text :payload
      t.text :data

      t.timestamps
    end
  end
end