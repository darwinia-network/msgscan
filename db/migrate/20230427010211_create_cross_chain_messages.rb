class CreateCrossChainMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :cross_chain_messages do |t|
      t.integer :src_blockchain_id
      t.string :dst_blockchain_id
      t.integer :nonce
      t.integer :status
      t.timestamp :sent_at
      t.integer :sent_at_event_id
      t.string :sent_at_event_type
      t.timestamp :executed_at
      t.integer :executed_at_event_id
      t.string :executed_at_event_type
      t.text :execution_error
      t.integer :execution_error_event_id
      t.string :execution_error_event_type
      t.string :from_dapp
      t.string :to_dapp
      t.text :payload

      t.timestamps

      t.index %w[sent_at_event_type sent_at_event_id], name: 'index_cross_chain_messages_on_sent_at_event'
    end
  end
end
