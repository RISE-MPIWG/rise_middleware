require_relative '../config/boot'
require_relative '../config/environment'
require 'clockwork'

module Clockwork
  handler do |job, time|
    puts "Running #{job}, at #{time}"
    job.to_s.constantize.perform_later
  end
  every(1.day, 'UpdateCollectionIndexesJob', at: '04:00')
end
