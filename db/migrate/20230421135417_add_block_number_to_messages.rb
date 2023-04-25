class AddBlockNumberToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :block_number, :integer
  end
end
