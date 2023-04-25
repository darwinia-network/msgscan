class AddBlocksPerScanToBlockchains < ActiveRecord::Migration[7.0]
  def change
    add_column :blockchains, :blocks_per_scan, :integer, default: 20_000
  end
end
