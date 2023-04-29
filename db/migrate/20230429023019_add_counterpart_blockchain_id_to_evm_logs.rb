class AddCounterpartBlockchainIdToEvmLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :evm_logs, :counterpart_blockchain_id, :integer
    add_column :evm_logs, :direction, :integer, comment: '0: out, 1: in'
  end
end
