class ChangeTableNameOfChains < ActiveRecord::Migration[7.0]
  def change
    rename_table :chains, :blockchains
    rename_column :channels, :from_chain_id, :from_blockchain_id
    rename_column :channels, :to_chain_id, :to_blockchain_id
    rename_column :last_tracked_blocks, :chain_id, :blockchain_id
  end
end
