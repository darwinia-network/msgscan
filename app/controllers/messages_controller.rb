class MessagesController < ApplicationController
  def index
    @messages = CrossChainMessage.latest_messages
  end

  def show
    @message = CrossChainMessage.find(params[:id])
  end
end
