class AddExplorerBlockToBlockchains < ActiveRecord::Migration[7.0]
  def change
    add_column :blockchains, :explorer_block_url, :string
  end
end
