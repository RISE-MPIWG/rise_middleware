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

require 'rails_helper'

RSpec.describe ResearchToolCollection, type: :model do
  it { is_expected.to belong_to(:research_tool).inverse_of(:research_tool_collections) }
  it { is_expected.to belong_to(:collection).inverse_of(:research_tool_collections) }
end
