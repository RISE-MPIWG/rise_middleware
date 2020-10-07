class RefreshAllCollectionResourcesJob < ApplicationJob
  queue_as :default

  def perform(args)
    organisations = Organisation.where.not(api_url: nil)
    stream_id = "user_info_channel_#{args[:user_id]}"
    organisations.each do |organisation|
      begin
        rcs = RemoteCollectionsService.new(organisation.id)
        rcs.refresh_collections
        ActionCable.server.broadcast(stream_id, type: :notice, message: "#{I18n.t('job_completed')}: #{I18n.t('refresh_collections_for')} #{organisation.name}")
      rescue
        ActionCable.server.broadcast(stream_id, type: :error, message: "#{I18n.t('error_occured')}: #{I18n.t('refresh_collections_for')} #{organisation.name}")
      end
    end
    collections = Collection.all
    collections.each do |collection|
      args[:collection_id] = collection.id
      RefreshCollectionResourcesJob.perform_later(args)
    end
  end
end
