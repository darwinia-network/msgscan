class MessagesController < ApplicationController
  def index
    @messages = CrossChainMessage.order(sent_at: :desc).page(params[:page])
  end
end
