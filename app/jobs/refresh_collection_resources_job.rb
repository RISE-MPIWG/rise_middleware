class RefreshCollectionResourcesJob < ApplicationJob
  queue_as :default

  def perform(args)
    stream_id = "user_info_channel_#{args[:user_id]}"
    begin
      RemoteResourcesService.refresh_resources(args[:collection_id])
      ActionCable.server.broadcast(stream_id, type: :notice, message: "#{I18n.t('job_completed')}: #{I18n.t('refresh_index_for')} #{Collection.find(args[:collection_id])}")
    rescue Exceptions::RemoteError => e
      ActionCable.server.broadcast(stream_id, type: :error, message: "#{I18n.t('error_occured')}: #{I18n.t('refresh_index_for')} #{Collection.find(args[:collection_id])} - #{e}")
    end
    UserMailer.job_finished_notification(User.find(args[:user_id])).deliver_now
  end
end
