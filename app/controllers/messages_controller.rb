class MessagesController < ApplicationController
  def index
    @messages = CrossChainMessage.latest_messages
  end

  def show
    @message = CrossChainMessage.find(params[:id])
  end

  # @route POST `/search`
  def search
    tx_hash = params[:message][:tx_hash]

    @message = CrossChainMessage.find_by src_transaction_hash: tx_hash

    render :show
  end
end
