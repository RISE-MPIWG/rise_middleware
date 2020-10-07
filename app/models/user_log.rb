# == Schema Information
#
# Table name: user_logs
#
#  id              :bigint(8)        not null, primary key
#  loggable_type   :string
#  loggable_id     :bigint(8)
#  subject_type    :string
#  subject_id      :bigint(8)
#  organisation_id :bigint(8)
#  controller      :string
#  action          :string
#  raw_request     :jsonb
#  request_origin  :string
#  request_method  :string
#  request_body    :string
#  request_params  :jsonb
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class UserLog < ApplicationRecord
  belongs_to :loggable, polymorphic: true
  belongs_to :subject, polymorphic: true, optional: true
  belongs_to :organisation

  def self.record_activity(attributes = {})
    UserLog.create(attributes)
  end
end
