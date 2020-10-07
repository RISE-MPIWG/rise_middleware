# == Schema Information
#
# Table name: resources
#
#  id                :bigint(8)        not null, primary key
#  created_by_id     :integer
#  uuid              :uuid             not null
#  original_uuid     :string           default("")
#  remote_updated_at :datetime
#  collection_id     :bigint(8)
#  name              :string
#  uri               :string
#  contents          :jsonb
#  metadata          :jsonb
#  archived          :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Resource < ApplicationRecord
  include Archivable
  include UuidFindable
  include Metadatable
  acts_as_taggable

  default_scope { order(name: :asc) }

  delegate :public_access?, to: :collection

  scope :with_public_access, -> { joins(:collection).where('collections.access_type' => :public_access) }

  belongs_to :collection, inverse_of: :resources

  has_one :organisation, through: :collection, inverse_of: :resources
  
  has_many :sections, inverse_of: :resource
  has_many :content_units, through: :sections

  has_many :corpus_resources, inverse_of: :resource
  has_many :corpora, through: :corpus_resources
  belongs_to :created_by, class_name: "User", foreign_key: 'created_by_id', optional: true

  def to_s
    name
  end

  def full_name
    "#{collection.name} > #{name}"
  end

  def collection_uuid
    collection.uuid
  end

  def not_requested_by(user)
    UserResource.find_by(user_id: user.id, resource_id: id).nil? || UserResource.find_by(user_id: user.id, resource_id: id).access_right == :not_requested
  end

  def pull_sections(user)
    RemoteSectionsService.new(self, user).refresh_sections
  end

  def pull_full_text(user)
    if sections.empty?
      pull_sections(user)
      reload
    end
    sections.each do |section|
      if section.content_units.empty?
        section.pull_content_units(user)
        section.reload
      end
    end
  end

  def self.by_tag(tag)
    tagged_with([tag], any: true, wild: true)
  end

  def self.by_tags(tags_array)
    tagged_with(tags_array, any: true, wild: true)
  end

  def self.by_any_metadata_field(value)
    results = ActiveRecord::Base.connection.execute("select id from resources join jsonb_each_text(resources.metadata) e on true where e.value ilike '%#{value}%';")
    Resource.where(id: results.column_values(0))
  end
end
