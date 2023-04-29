class AddCrossChainMessageIdToEvmLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :evm_logs, :cross_chain_message_id, :integer
  end
end
