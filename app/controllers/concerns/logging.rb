module Logging
  extend ActiveSupport::Concern

  included do
    after_action :log_activity
  end

  private

  def log_activity
    return unless current_user

    attributes = {}
    attributes[:loggable] = current_user
    attributes[:organisation_id] = current_user.organisation_id
    attributes[:subject] = nil
    attributes[:controller] = controller_name
    attributes[:action] = action_name
    attributes[:request_origin] = request.remote_ip
    attributes[:request_method] = request.method
    attributes[:request_params] = request.params.transform_values!(&:to_s).to_s
    LogActivityJob.perform_later(attributes)
  end
end
