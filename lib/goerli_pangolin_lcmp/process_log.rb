# events_desc = {
#   'MessageAccepted' => {
#     'from_chain_id' => 1,
#     'to_chain_id' => 2
#   },
# }
def process_log(_events_desc, log)
  if log['event_name'] == 'MessageAccepted'
    puts '----------------------------------------------------------------'
    # create a new message
    CrossChainMessage.create({})
    # save log to db
    # update message's sent_at_event
  elsif log['event_name'] == 'MessageDispatched'
    puts '----------------------------------------------------------------'

    # update message's executed_at_event
  elsif log['event_name'] == 'DappErrCatched'
    puts '----------------------------------------------------------------'
    # update message's executed_at_event
  elsif log['event_name'] == 'MessageDelivered'
    puts '----------------------------------------------------------------'
    # update message's executed_at_event
  end
end
