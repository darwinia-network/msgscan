class RemoveColumnsFromEvents < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :blockchain_id, :integer
    remove_column :events, :counterpart_blockchain_id, :integer
    remove_column :events, :direction, :integer
  end
end
