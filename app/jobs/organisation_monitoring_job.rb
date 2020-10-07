class OrganisationMonitoringJob < ApplicationJob
  queue_as :default

  def perform()
    organisations = Organisation.where(api_mapping_module: 'standard')

    organisations.each do |organisation|
      begin
        remote_resource_matcher_service = RemoteCollectionsMatcherService.new(organisation)
        remote_resource_matcher_service.match_collections
      rescue StandardError => e
        puts e.message
        puts e.backtrace.inspect
      end
    end

  end

end
