class Event < ApplicationRecord
  belongs_to :cross_chain_message, optional: true
  belongs_to :event_source, polymorphic: true

  delegate :transaction_hash, to: :event_source, allow_nil: true
  delegate :block_number, to: :event_source, allow_nil: true
end
