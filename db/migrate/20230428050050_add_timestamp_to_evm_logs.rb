class AddTimestampToEvmLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :evm_logs, :log_at, :timestamp
  end
end
