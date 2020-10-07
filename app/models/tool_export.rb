# == Schema Information
#
# Table name: tool_exports
#
#  id                :bigint(8)        not null, primary key
#  uuid              :uuid             not null
#  name              :string
#  notes             :text
#  user_id           :bigint(8)
#  resource_metadata :jsonb            not null
#  research_tool_id  :bigint(8)
#  file_data         :string
#  privacy_type      :integer          default("private_access")
#  archived          :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ToolExport < ApplicationRecord
  include Archivable
  include UuidFindable

  include FileUploader[:file]

  belongs_to :user, inverse_of: :tool_exports
  belongs_to :research_tool, inverse_of: :tool_exports, optional: true

  PRIVACY_TYPES = { private_access: 0, public_access: 1 }.freeze
  enum privacy_type: PRIVACY_TYPES

  def to_s
    name
  end
end
