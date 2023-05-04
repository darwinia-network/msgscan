require 'eth'
include Eth

require_relative '../evm/evm_track_helper'
require_relative '../abi/events_abi'
require_relative '../utils'
require_relative '../evm/scan_logs'
require_relative '../../config/environment'

def scan_logs_of_goerli
  abi = EventsAbi.new('./lib/abi/lane-events.json')

  contracts = %w[
    0x9B5010d562dDF969fbb85bC72222919B699b5F54
    0x0F6e081B1054c59559Cf162e82503F3f560cA4AF
  ]

  goerli = Blockchain.find_by_name('goerli')

  scan_logs_loop(goerli, contracts, abi)
end
