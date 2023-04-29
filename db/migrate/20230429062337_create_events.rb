class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :event_source_type
      t.integer :event_source_id

      t.timestamps
    end
  end
end
