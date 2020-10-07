require 'resque'
require 'resque/tasks'
require 'resque/pool/tasks'

namespace :resque do
  task :setup do
    ENV['QUEUE'] ||= '*'
    Resque.redis = 'redis:6379'
  end

  task "pool:setup" do
    # close any sockets or files in pool manager
    ActiveRecord::Base.connection.disconnect!
    # and re-open them in the resque worker parent
    Resque::Pool.after_prefork do |_job|
      ActiveRecord::Base.establish_connection
    end
  end
end
