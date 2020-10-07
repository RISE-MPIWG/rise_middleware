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

class ResearchTool < ApplicationRecord
  include UuidFindable
  include Archivable

  has_many :organisation_research_tools, inverse_of: :research_tool
  has_many :organisations, through: :organisation_research_tools

  has_many :collections, inverse_of: :research_tools, foreign_key: :research_tool_id
  has_many :research_tool_collections, inverse_of: :research_tools, foreign_key: :research_tool_id
  has_many :tool_exports, inverse_of: :research_tool

  belongs_to :created_by, class_name: "User", foreign_key: 'created_by_id', optional: true

  def to_s
    name
  end

  def enabled_organisations
    enabled_organisation_ids = OrganisationResearchTool.where(research_tool_id: id, access_right: :enabled).map(&:organisation_id)
    Organisation.where(id: enabled_organisation_ids)
  end

  def set_access_right_for_collection(collection, access_right)
    research_tool_collection = ResearchToolCollection.find_or_create_by(research_tool_id: id, collection_id: collection.id)
    research_tool_collection.access_right = access_right
    research_tool_collection.save
  end
end
