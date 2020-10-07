class RemoteResourcesService
  attr_reader :collection_id

  def self.refresh_resources(collection_id)
    new(collection_id).refresh_resources
  end

  def initialize(collection_id)
    @collection_id = collection_id
  end

  def refresh_resources
    clear_resources!
    collection = find_collection
    case collection.api_mapping_module.to_sym
    when :ctext
      CtextResourcesService.refresh_resources(collection)
    when :standard
      rise_admin_org_col = OrganisationCollection.find_by(organisation: Organisation.find_by_slug(:rise_admin), collection: collection)
      api_key = rise_admin_org_col.api_key if rise_admin_org_col
      StandardResourcesService.refresh_resources(collection, api_key)
    when :kanripo
      KanripoResourcesService.refresh_resources(collection)
    when :perseus
      PerseusResourcesService.refresh_resources(collection)
    when :esukhia
      EsukhiaResourcesService.refresh_resources(collection)
    when :dts
      DtsResourcesService.refresh_resources(collection)
    end

    # not very elegant, we grab the metadata of the first resource metadata if it exists...
    collection.metadata = collection.resources.first.metadata if collection.resources.first && collection.resources.first.metadata
  end
  def find_collection
    Collection.find(collection_id)
  end

  def clear_resources!
    ActiveRecord::Base.transaction do
      section_ids = Section.joins(:resource).where(resources: { collection_id: collection_id }).pluck(:id)
      ContentUnit.where(section_id: section_ids).delete_all
      Section.where(id: section_ids).delete_all
      Resource.where(collection_id: collection_id).delete_all
    end
  end
end
