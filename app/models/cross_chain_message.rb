class CrossChainMessage < ApplicationRecord
  belongs_to :src_chain, class_name: 'Blockchain', foreign_key: 'src_blockchain_id'
  belongs_to :dst_chain, class_name: 'Blockchain', foreign_key: 'dst_blockchain_id'

  belongs_to :initiated_at_event, foreign_key: 'initiated_at_event_id', class_name: 'Event', optional: true
  belongs_to :delivered_at_event, foreign_key: 'delivered_at_event_id', class_name: 'Event', optional: true
  belongs_to :execution_error_event, foreign_key: 'execution_error_event_id', class_name: 'Event', optional: true
  belongs_to :confirmed_at_event, foreign_key: 'confirmed_at_event_id', class_name: 'Event', optional: true

  belongs_to :channel

  has_many :cross_chain_message_events
  has_many :events, through: :cross_chain_message_events

  delegate :block_number, to: :initiated_at_event, allow_nil: true

  def status_bar
    first = initiated_at.nil? ? '◽' : '◾'
    second = delivered_at.nil? ? '◽' : '◾'
    third = confirmed_at.nil? ? '◽' : '◾'
    first + second + third
  end

  def src_tx_hash
    src_transaction_hash
  end

  def dst_tx_hash
    dst_transaction_hash
  end

  def self.latest_messages(limit = 48)
    CrossChainMessage.includes(:src_chain, :dst_chain,
                               initiated_at_event: :event_source).order(initiated_at: :desc).limit(limit)
  end

  def broadcast_to_frontend
    broadcast_update_to(
      'messages', partial: 'messages/messages',
                  locals: { messages: CrossChainMessage.latest_messages },
                  target: 'messages'
    )
  end
end
