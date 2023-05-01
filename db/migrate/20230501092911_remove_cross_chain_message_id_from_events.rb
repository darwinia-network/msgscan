class RemoveCrossChainMessageIdFromEvents < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :cross_chain_message_id
  end
end
