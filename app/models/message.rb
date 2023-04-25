class Message < ApplicationRecord
  belongs_to :channel

  validates :nonce, uniqueness: { scope: :channel_id }
end
