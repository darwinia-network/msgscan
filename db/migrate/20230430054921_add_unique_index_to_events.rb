class AddUniqueIndexToEvents < ActiveRecord::Migration[7.0]
  def change
    add_index :events, %i[event_source_type event_source_id], unique: true
  end
end
