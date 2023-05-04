class AddSrcTransactionHashToCrossChainMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :cross_chain_messages, :src_transaction_hash, :string
    add_column :cross_chain_messages, :dst_transaction_hash, :string
  end
end
