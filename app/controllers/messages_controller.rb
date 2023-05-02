class MessagesController < ApplicationController
  def index
    @messages = CrossChainMessage.latest_messages
  end
end
