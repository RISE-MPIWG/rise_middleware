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

require 'rails_helper'

RSpec.describe ToolExport, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
