class EvmLcmpLog < ApplicationRecord
  has_one :cross_chain_message_sent, as: :sent_at_event
  has_one :cross_chain_message_executed, as: :executed_at_event
  belongs_to :blockchain

  enum :direction, { out: 0, in: 1 }, prefix: true

  after_create :process_log

  def process_log
    case event_name
    when 'MessageAccepted'
      process_message_accepted
    when 'MessageDispatched'
      # process_message_dispatched
    when 'DappErrCatched'
      # process_dapp_err_catched
    when 'DappErrCatchedBytes'
      # process_dapp_err_catched_bytes
    when 'MessageDelivered'
      # process_message_delivered
    end
  end

  def process_message_accepted
    result = CrossChainMessage.create(
      {
        src_blockchain_id: blockchain_id,
        dst_blockchain_id: counterpart_blockchain_id,
        nonce: args['nonce'],
        sent_at: log_at,
        sent_at_event: self,
        from_dapp: args['source'],
        to_dapp: args['target'],
        payload: args['encoded']
      }
    )
    raise result.errors.full_messages.to_sentence unless result.errors.empty?

    update cross_chain_message_id: result.id
  end

  # def process_message_dispatched
  #   result = CrossChainMessage.find_by(
  #     {
  #       src_blockchain_id: counterpart_blockchain_id,
  #       dst_blockchain_id: blockchain_id,
  #       nonce: args['nonce']
  #     }
  #   )
  #   if result.nil?
  #   else
  #   end

  #   result.update(
  #     {
  #       dispatched_at: log_at,
  #       dispatched_at_event: self
  #     }
  #   )
  # end
end
