class CreateEvmLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :evm_logs do |t|
      t.integer :blockchain_id
      t.integer :cross_chain_message_id
      t.string :address
      t.string :topics, array: true
      t.integer :block_number
      t.text :data
      t.integer :index
      t.string :transaction_hash
      t.integer :transaction_id

      t.timestamps
    end
  end
end
