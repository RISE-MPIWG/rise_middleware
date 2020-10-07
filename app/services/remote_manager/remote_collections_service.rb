class RemoteCollectionsService
  attr_reader :organisation_id

  def self.refresh_collections(organisation_id)
    new(organisation_id).refresh_collections
  end

  def initialize(organisation_id)
    @organisation_id = organisation_id
  end

  def refresh_collections
    organisation = find_organisation
    case organisation.api_mapping_module.to_sym
    when :standard
      clear_organisation_cache!(organisation)
      scs = StandardCollectionsService.new(organisation, api_key)
      scs.refresh_collections
      create_organisation_collection_for_rise_admin if api_key
    when :dts
      DtsCollectionsService.new(organisation.id).refresh_collections 
    end
  end

  def create_organisation_collection_for_rise_admin
    rise_admin = Organisation.find_by_slug(:rise_admin)
    find_organisation.collections.each do |collection|
      OrganisationCollection.create(
        collection_id: collection.id,
        organisation_id: rise_admin.id,
        api_key: api_key,
        access_right: :read
      )
    end
  end

  def find_organisation
    @find_organisation ||= Organisation.find(organisation_id)
  end

  def api_key
    find_organisation.api_key
  end

  def clear_organisation_cache!(organisation)
    ActiveRecord::Base.transaction do
      collection_ids = organisation.collections.pluck(:id)
      section_ids = Section.joins(:resource).where(resources: { collection_id: collection_ids }).pluck(:id)
      ContentUnit.where(section_id: section_ids).delete_all
      Section.where(id: section_ids).delete_all
      Resource.where(collection_id: collection_ids).delete_all
      Collection.where(organisation_id: organisation.id).delete_all
    end
  end
end
