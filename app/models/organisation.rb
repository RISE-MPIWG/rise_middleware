# == Schema Information
#
# Table name: organisations
#
#  id                             :bigint(8)        not null, primary key
#  created_by_id                  :integer
#  name                           :string
#  slug                           :string
#  api_url                        :string
#  api_mapping_module             :integer          default("no_mapping_module")
#  saml_issuer_uri                :string
#  api_key                        :string
#  organisation_type              :integer
#  archived                       :boolean          default(FALSE)
#  default_collection_access_type :integer          default("private_access")
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

class Organisation < ApplicationRecord
  include Archivable

  ORGANISATION_TYPES = { "research_institute" => 0, "university" => 1, "library" => 2, "vendor" => 3, "public_vendor" => 4 }.freeze

  enum organisation_type: ORGANISATION_TYPES
  enum api_mapping_module: Collection::API_MAPPING_MODULE_SLUGS
  enum default_collection_access_type: Collection::ACCESS_TYPES

  has_many :users, inverse_of: :organisation
  has_many :collections, inverse_of: :organisation
  has_many :organisation_collections, inverse_of: :organisation

  has_many :collections
  has_many :resources, through: :collections, inverse_of: :organisation

  has_many :organisation_research_tools, inverse_of: :organisation
  has_many :research_tools, through: :organisation_research_tools

  validates :slug, uniqueness: true
  validates :api_url, url: { allow_blank: true }

  scope :skip_organisation, ->(organisation) { where.not(id: organisation.id) }
  scope :resource_consumers, -> { where(organisation_type: %i[research_institute university]) }

  # has_many :organisation_resources
  # has_many :resources, through: :organisation_resources

  def to_s
    if name.present?
      name
    elsif slug.present?
      slug
    elsif saml_issuer_uri
      saml_issuer_uri
    end
  end

  def collections_for_access_right(access_right)
    accessible_collection_ids = OrganisationCollection.where(organisation_id: id, access_right: access_right).map(&:collection_id) + Collection.with_public_access.pluck(:id)
    Collection.where(id: accessible_collection_ids)
  end

  def access_right_for_collection(collection)
    oc = OrganisationCollection.find_by(organisation_id: id, collection_id: collection.id)
    oc.access_right if oc.present?
  end

  def resources_for_access_right(access_right)
    accessible_collection_ids = OrganisationCollection.where(organisation_id: id, access_right: access_right).map(&:collection_id) + Collection.with_public_access.pluck(:id)
    Resource.where(collection_id: accessible_collection_ids)
  end

  def set_access_right_for_collection(collection, access_right)
    organisation_collection = OrganisationCollection.find_or_create_by(organisation_id: id, collection_id: collection.id)
    organisation_collection.access_right = access_right
    organisation_collection.save
  end

  def set_access_right_for_research_tool(research_tool, access_right)
    organisation_research_tool = OrganisationResearchTool.find_or_create_by(organisation_id: id, research_tool_id: research_tool.id)
    organisation_research_tool.access_right = access_right
    organisation_research_tool.save
  end

  def accessible_research_tools
    ResearchTool.active.joins(:organisation_research_tools).where(organisation_research_tools: { access_right: :enabled })
  end

  def self.from_saml_issuer_uri(saml_issuer_uri)
    where(saml_issuer_uri: saml_issuer_uri).first_or_create do |organisation|
    end
  end
end
