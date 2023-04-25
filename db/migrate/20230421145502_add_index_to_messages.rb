class AddIndexToMessages < ActiveRecord::Migration[7.0]
  def change
    add_index :messages, %i[channel_id nonce], unique: true
  end
end
