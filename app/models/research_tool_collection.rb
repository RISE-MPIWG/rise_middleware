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

class ResearchToolCollection < ApplicationRecord
  belongs_to :research_tool, inverse_of: :research_tool_collections
  belongs_to :collection, inverse_of: :research_tool_collections

  ACCESS_RIGHTS = { no_access: 0, read: 1, mine: 2 }.freeze
  enum access_right: ACCESS_RIGHTS
end
