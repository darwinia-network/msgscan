class AddColumnsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :blockchain_id, :integer
    add_column :events, :counterpart_blockchain_id, :integer
    add_column :events, :direction, :boolean

    remove_column :evm_lcmp_logs, :counterpart_blockchain_id, :integer
    remove_column :evm_lcmp_logs, :direction, :integer
  end
end
