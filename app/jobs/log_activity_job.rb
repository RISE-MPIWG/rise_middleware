class LogActivityJob < ApplicationJob
  queue_as :default

  def perform(args)
    UserLog.record_activity(args)
  end
end
