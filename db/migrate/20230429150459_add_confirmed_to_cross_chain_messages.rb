class AddConfirmedToCrossChainMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :cross_chain_messages, :confirmed_at, :timestamp
    add_column :cross_chain_messages, :confirmed_at_event_id, :integer
  end
end
