require_relative './preprocess_log'
def scan_logs(chain_rpc, from_block, to_block, contracts, abi)
  helper = EvmTrackHelper.new(chain_rpc)
  helper.get_logs(contracts, [abi.topics], from_block, to_block).each do |log|
    # TODO: add log to task queue
    yield preprocess_log(helper, abi, log)
  end
end

# events = [
#   {
#     name: 'MessageAccepted',
#     for_messages: {
#       from_chain: 'goerli',
#       to_chain: 'pangolin'
#     }
#   },
#   {
#     name: 'MessageDispatched',
#     for_messages: {
#       from_chain: 'pangolin',
#       to_chain: 'goerli'
#     }
#   },
#   {
#     name: 'DappErrCatched',
#     for_messages: {
#       from_chain: 'pangolin',
#       to_chain: 'goerli'
#     }
#   },
#   {
#     name: 'DappErrCatchedBytes',
#     for_messages: {
#       from_chain: 'pangolin',
#       to_chain: 'goerli'
#     }
#   },
#   {
#     name: 'MessageDelivered',
#     for_messages: {
#       from_chain: 'goerli',
#       to_chain: 'pangolin'
#     }
#   }
# ]
