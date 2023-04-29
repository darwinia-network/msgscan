class ChangeDstBlockchainIdTypeOfCrossChainMessages < ActiveRecord::Migration[7.0]
  def up
    remove_column :cross_chain_messages, :dst_blockchain_id
    add_column :cross_chain_messages, :dst_blockchain_id, :integer
  end

  def down
    remove_column :cross_chain_messages, :dst_blockchain_id
    add_column :cross_chain_messages, :dst_blockchain_id, :string
  end
end
