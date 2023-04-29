class AddUniqueIndexToCrossChainMessages < ActiveRecord::Migration[7.0]
  def change
    add_index :cross_chain_messages,
              %i[src_blockchain_id dst_blockchain_id channel_id nonce],
              unique: true,
              name: 'index_cross_chain_messages_on_src_and_dst_and_ch_and_nonce'
  end
end
