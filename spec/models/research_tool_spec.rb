# == Schema Information
#
# Table name: research_tools
#
#  id            :bigint(8)        not null, primary key
#  created_by_id :integer
#  uuid          :uuid             not null
#  name          :string
#  description   :text
#  url           :string
#  slug          :string
#  archived      :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe ResearchTool, type: :model do
  describe "Associations" do
    it { is_expected.to have_many(:organisation_research_tools) }
    it { is_expected.to have_many(:organisations) }
    it { is_expected.to have_many(:research_tool_collections).with_foreign_key(:research_tool_id) }
    it { is_expected.to have_many(:collections).with_foreign_key(:research_tool_id) }
    it { is_expected.to belong_to(:created_by) }
  end

  describe "Methods" do
    let(:research_tool) { create :research_tool }
    let(:organisation_research_tools) { create_list :organisation_research_tool, 3, access_right: :enabled, research_tool: research_tool }

    it "shoud return a name of research tool" do
      expect(research_tool.to_s).to eq research_tool.name
    end

    it "should return organisations enabled for research tool" do
      organisation_research_tools
      expect(research_tool.enabled_organisations.count).to eq(3)
    end
  end
end
