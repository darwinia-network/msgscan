class AddIndexToEvmLcmpLog < ActiveRecord::Migration[7.0]
  def change
    add_index :evm_lcmp_logs,
              %i[blockchain_id block_number transaction_index log_index],
              unique: true,
              name: 'index_evm_lcmp_logs_on_4_columns'
  end
end
