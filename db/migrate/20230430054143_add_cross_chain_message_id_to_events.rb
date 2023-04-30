class AddCrossChainMessageIdToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :cross_chain_message_id, :integer
  end
end
