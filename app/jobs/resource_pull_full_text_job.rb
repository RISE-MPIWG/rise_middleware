class ResourcePullFullTextJob < ApplicationJob
  queue_as :default

  def perform(args)
    resource = Resource.find(args[:resource_id])
    user = User.find(args[:user_id])
    resource.pull_full_text(user)
  end
end
