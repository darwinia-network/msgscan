class DropTableContracts < ActiveRecord::Migration[7.0]
  def change
    drop_table :contracts
  end
end
