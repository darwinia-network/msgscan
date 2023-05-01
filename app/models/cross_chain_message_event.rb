class CrossChainMessageEvent < ApplicationRecord
  belongs_to :cross_chain_message
  belongs_to :event
end
