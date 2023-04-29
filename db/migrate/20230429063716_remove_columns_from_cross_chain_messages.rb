class RemoveColumnsFromCrossChainMessages < ActiveRecord::Migration[7.0]
  def change
    remove_column :cross_chain_messages, :sent_at_event_type, :string
    remove_column :cross_chain_messages, :executed_at_event_type, :string
    remove_column :cross_chain_messages, :execution_error_event_type, :string
  end
end
