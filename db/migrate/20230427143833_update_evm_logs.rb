class UpdateEvmLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :evm_logs, :block_hash, :string
    add_column :evm_logs, :transaction_index, :integer
    add_column :evm_logs, :log_index, :integer
    add_column :evm_logs, :removed, :boolean
    add_column :evm_logs, :event_name, :string
    add_column :evm_logs, :args, :json
    remove_column :evm_logs, :index, :integer
  end
end
