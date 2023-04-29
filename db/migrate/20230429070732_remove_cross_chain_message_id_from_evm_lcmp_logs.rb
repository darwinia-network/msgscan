class RemoveCrossChainMessageIdFromEvmLcmpLogs < ActiveRecord::Migration[7.0]
  def change
    remove_column :evm_lcmp_logs, :cross_chain_message_id, :integer
  end
end
