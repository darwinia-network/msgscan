class MessagesController < ApplicationController
  def index
    @messages = CrossChainMessage.where.not(sent_at: [nil]).order(sent_at: :desc).page(params[:page])
  end
end
