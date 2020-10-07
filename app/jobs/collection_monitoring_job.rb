class CollectionMonitoringJob < ApplicationJob
  queue_as :default

  def perform()
    collections = Collection.where(api_mapping_module: :standard)

    collections.each do |collection|
      begin
        remote_resource_matcher_service = RemoteResourcesMatcherService.new(collection)
        remote_resource_matcher_service.match_resources
      rescue
        puts 'AHA SKIPEDEEDOO'
      end
    end
  end

end
