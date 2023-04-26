class MessagesController < ApplicationController
  def index
    @messages = Message.order(nonce: :desc).page(params[:page])
  end
end
