# == Schema Information
#
# Table name: organisation_research_tools
#
#  id               :bigint(8)        not null, primary key
#  organisation_id  :bigint(8)
#  research_tool_id :bigint(8)
#  access_right     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class OrganisationResearchTool < ApplicationRecord
  belongs_to :organisation, inverse_of: :organisation_research_tools
  belongs_to :research_tool, inverse_of: :organisation_research_tools

  ACCESS_RIGHTS = { disabled: 0, enabled: 1 }.freeze
  enum access_right: ACCESS_RIGHTS
end
