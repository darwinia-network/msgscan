class AddChannelIdToCrossChainMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :cross_chain_messages, :channel_id, :integer
  end
end
