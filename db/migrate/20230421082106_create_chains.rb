class CreateChains < ActiveRecord::Migration[7.0]
  def change
    create_table :chains do |t|
      t.string :name
      t.string :explorer

      t.timestamps
    end
  end
end
