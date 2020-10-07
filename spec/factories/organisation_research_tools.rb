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

FactoryBot.define do
  factory :organisation_research_tool do
    organisation
    research_tool
    trait(:enabled) { access_right { :enabled } }
  end
end
