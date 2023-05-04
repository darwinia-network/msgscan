require 'eth'
include Eth

require_relative '../evm/evm_track_helper'
require_relative '../abi/events_abi'
require_relative '../utils'
require_relative '../evm/scan_logs'
require_relative '../../config/environment'

def scan_logs_of_pangolin
  abi = EventsAbi.new('./lib/abi/lane-events.json')

  contracts = %w[
    0xabd165de531d26c229f9e43747a8d683ead54c6c
    0xb59a893f5115c1ca737e36365302550074c32023
  ]

  pangolin = Blockchain.find_by_name('pangolin')

  scan_logs_loop(pangolin, contracts, abi)
end
