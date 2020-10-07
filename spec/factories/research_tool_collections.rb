# == Schema Information
#
# Table name: research_tool_collections
#
#  id               :bigint(8)        not null, primary key
#  research_tool_id :bigint(8)
#  collection_id    :bigint(8)
#  access_right     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryBot.define do
  factory :research_tool_collection do
    research_tool
    collection
  end
end
