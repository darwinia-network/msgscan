class ChangeDirectionTypeOfEvents < ActiveRecord::Migration[7.0]
  def up
    remove_column :events, :direction, :boolean
    add_column :events, :direction, :integer
  end

  def down
    remove_column :events, :direction, :integer
    add_column :events, :direction, :boolean
  end
end
