class EventsAbi
  def initialize(abi_file_path)
    @abi = JSON.parse File.read(abi_file_path)

    @interfaces = {}
    @topics = {}
    @abi.each do |item|
      @interfaces[snake_case(item['name'])] = item
      @topics[snake_case(item['name'])] = Abi::Event.compute_topic(item)
    end
  end

  attr_reader :abi, :interfaces

  def topic(name)
    @topics[snake_case(name)]
  end

  def topics
    @topics.values
  end

  def [](name)
    @interfaces[snake_case(name)]
  end
end

# require 'json'
# require 'eth'
# include Eth
# require_relative '../utils'
# abi = EventsAbi.new('./lib/abi/lane-events.json')
# # puts abi.topic('MessageAccepted')
# # puts abi.topic('message_accepted')
# # puts abi.topics
# puts abi['MessageAccepted']['inputs']
