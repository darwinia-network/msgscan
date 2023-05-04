Rails.logger = Logger.new($stdout)
require_relative '../goerli_pangolin_lcmp/scan_goerli_logs'
require_relative '../goerli_pangolin_lcmp/scan_pangolin_logs'

namespace :goerli_pangolin_lcmp do
  desc 'scan events of goerli'
  task scan_events_of_goerli: :environment do
    scan_logs_of_goerli
  end

  desc 'scan events of pangolin'
  task scan_events_of_pangolin: :environment do
    scan_logs_of_pangolin
  end
end
