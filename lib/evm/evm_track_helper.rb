include Eth

class EvmTrackHelper
  # build EvmTrackHelper instance
  def initialize(url)
    @client = Eth::Client::Http.new(url)
  end

  attr_reader :client

  def get_latest_block_number
    client.eth_block_number['result'].to_i(16) - 12
  end

  def get_block_by_number(number)
    block = client.eth_get_block_by_number(number, true)['result']
    return if block.nil?

    block['number'] = block['number'].to_i(16)
    block
  end

  def get_latest_block
    start = Time.now
    latest_block_number = get_latest_block_number
    block = get_block_by_number(latest_block_number)
    time_elapsed = Time.now - start
    puts "time elapsed: #{time_elapsed} ms"
    block
  end

  def track_block(start_from_block = nil)
    last_tracked_block =
      (
        if start_from_block.nil?
          get_latest_block
        else
          get_block_by_number(start_from_block)
        end
      )

    loop do
      block_number_to_track = last_tracked_block['number'] + 1

      # run too fast, sleep ns and retry
      if block_number_to_track > get_latest_block_number
        seconds_to_sleep = 5
        # puts "run too fast, sleep #{seconds_to_sleep}s and retry"
        sleep seconds_to_sleep
        next
      end

      new_block = get_block_by_number(block_number_to_track)

      # do something with new_block
      puts "new block: #{new_block['number']}"
      yield new_block

      # update last_tracked_block
      last_tracked_block = new_block
    rescue StandardError => e
      puts "error: #{e}"
    end
  end

  def get_transactions(block, to, method_id)
    raise 'Wrong method id' if method_id.length != 10

    block['transactions'].select do |tx|
      tx['to'] == to.downcase && tx['input'].start_with?(method_id.downcase)
    end
  end

  # tx attributes: [
  #   "blockHash",
  #   "blockNumber",
  #   "hash",
  #   "accessList",
  #   "chainId",
  #   "from",
  #   "gas",
  #   "gasPrice",
  #   "input",
  #   "maxFeePerGas",
  #   "maxPriorityFeePerGas",
  #   "nonce",
  #   "r",
  #   "s",
  #   "to",
  #   "transactionIndex",
  #   "type",
  #   "v",
  #   "value"
  # ]
  # method_id: selector, for example: 0x8f0e6d6b
  def track_transactions(to, method_id, start_from_block = nil, &block)
    track_block(start_from_block) do |new_block|
      transactions = get_transactions(new_block, to, method_id)
      transactions.each(&block)
    end
  end

  # A transaction with a log with topics [A, B] will be matched by the following topic filters:
  #   [] “anything”
  #   [A] “A in first position (and anything after)”
  #   [null, B] “anything in first position AND B in second position (and anything after)”
  #   [A, B] “A in first position AND B in second position (and anything after)”
  #   [[A, B], [A, B]] “(A OR B) in first position AND (A OR B) in second position (and anything after)”
  #
  # From: https://docs.alchemy.com/docs/deep-dive-into-eth_getlogs
  def get_logs(addresses, topics, from_block, to_block)
    resp =
      client.eth_get_logs(
        {
          address: addresses,
          from_block: from_block.to_s(16),
          to_block: to_block.to_s(16),
          topics:
        }
      )
    raise resp['error'].to_json if resp['error']

    resp['result']
  end
end
