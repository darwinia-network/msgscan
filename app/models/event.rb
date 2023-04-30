class Event < ApplicationRecord
  belongs_to :cross_chain_message, optional: true
  belongs_to :event_source, polymorphic: true
end
