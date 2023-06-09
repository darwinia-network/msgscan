# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
require "./#{File.dirname(__FILE__)}/environment.rb"
env :PATH, ENV['PATH']
every 1.minute do
  Blockchain.all.each do |chain|
    rake "messages:scan_messaging_events_of[#{chain.id},#{chain.blocks_per_scan}]", environment: 'development'
  end
end
