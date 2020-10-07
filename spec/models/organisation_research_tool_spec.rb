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

require 'rails_helper'

RSpec.describe OrganisationResearchTool, type: :model do
  it { is_expected.to belong_to(:organisation).inverse_of(:organisation_research_tools) }
  it { is_expected.to belong_to(:research_tool).inverse_of(:organisation_research_tools) }
end
