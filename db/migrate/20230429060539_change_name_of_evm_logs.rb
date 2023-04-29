class ChangeNameOfEvmLogs < ActiveRecord::Migration[7.0]
  def change
    rename_table :evm_logs, :evm_lcmp_logs
  end
end
