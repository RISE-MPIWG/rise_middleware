# == Schema Information
#
# Table name: collections
#
#  id                 :bigint(8)        not null, primary key
#  created_by_id      :integer
#  uuid               :uuid             not null
#  original_uuid      :string
#  resources_url      :string
#  organisation_id    :bigint(8)
#  name               :string
#  slug               :string
#  api_url            :string
#  metadata           :jsonb            not null
#  archived           :boolean          default(FALSE)
#  access_type        :integer          default("private_access")
#  api_mapping_module :integer          default("no_mapping_module")
#  remote_updated_at  :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Collection < ApplicationRecord
  include Archivable
  include UuidFindable
  include Metadatable

  default_scope { order(name: :asc) }

  validates :api_url, url: { allow_blank: true }

  scope :with_public_access, -> { where(access_type: :public_access) }

  has_many :resources, inverse_of: :collection, dependent: :delete_all
  has_many :sections, through: :resources
  has_many :content_units, through: :resources
  belongs_to :organisation, inverse_of: :collections
  has_many :organisation_collections, inverse_of: :collection, dependent: :destroy

  has_many :research_tool_collections, inverse_of: :collection
  has_many :research_tools, through: :research_tool_collections

  belongs_to :created_by, class_name: "User", foreign_key: 'created_by_id', optional: true

  API_MAPPING_MODULE_SLUGS = { "no_mapping_module" => 0, "ctext" => 1, "fedora" => 2, "logart" => 3, "standard" => 4, "kanripo" => 5, "perseus" => 6, "csel" => 7, "esukhia" => 8, "dts" => 9}.freeze
  ACCESS_TYPES = { "private_access" => 0, "public_access" => 1 }.freeze

  enum api_mapping_module: API_MAPPING_MODULE_SLUGS
  enum access_type: ACCESS_TYPES

  def to_s
    name
  end

  def mapping_module_set?
    api_mapping_module.to_sym != :no_mapping_module
  end

  def resource_count
    resources.count
  end

  def clear_cache!
    ActiveRecord::Base.transaction do
      section_ids = Section.joins(:resource).where(resources: { collection_id: id }).pluck(:id)
      ContentUnit.where(section_id: section_ids)
      Section.where(id: section_ids).delete_all
      resources.delete_all
    end
  end

  def clear_resources!
    ActiveRecord::Base.transaction do
      clear_cache!
      resources.delete_all
    end
  end


  def self.from_slug(slug)
    Collection.find_by(slug: slug)
  end
  def admin_api_key
    rise_admin_org_col = OrganisationCollection.find_by(organisation: Organisation.find_by_slug(:rise_admin), collection: self)
  end
end
