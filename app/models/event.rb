class Event < ApplicationRecord
  belongs_to :event_source, polymorphic: true

  has_many :cross_chain_message_events
  has_many :cross_chain_messages, through: :cross_chain_message_events

  delegate :transaction_hash, to: :event_source, allow_nil: true
  delegate :block_number, to: :event_source, allow_nil: true
end
