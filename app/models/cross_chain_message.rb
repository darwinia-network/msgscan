class CrossChainMessage < ApplicationRecord
  belongs_to :src_chain, class_name: 'Blockchain', foreign_key: 'src_blockchain_id'
  belongs_to :dst_chain, class_name: 'Blockchain', foreign_key: 'dst_blockchain_id'

  belongs_to :sent_at_event, foreign_key: 'sent_at_event_id', optional: true
  belongs_to :executed_at_event, foreign_key: 'executed_at_event_id', optional: true
  belongs_to :execution_error_event, foreign_key: 'execution_error_event_id', optional: true
  belongs_to :confirmed_at_event, foreign_key: 'confirmed_at_event_id', optional: true

  belongs_to :channel

  has_many :events
end
