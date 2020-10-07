class RemoteSectionsService
  attr_reader :resource, :user

  def self.refresh_sections(resource, user = nil)
    new(resource, user).refresh_sections
  end

  def initialize(resource, user = nil)
    @resource = resource
    @user = user
  end

  def refresh_sections
    collection = find_collection

    case collection.api_mapping_module.to_sym
    when :standard
      StandardSectionsService.get_sections(resource, api_key)
    when :ctext
      CtextSectionsService.get_sections(resource, api_key)
    when :kanripo
      KanripoSectionsService.get_sections(resource)
    when :perseus
      PerseusSectionsService.get_sections(resource)
    when :esukhia
      EsukhiaSectionsService.get_sections(resource)
    end
  end

  # TODO : we might be able to cache the collection without using find_
  def find_collection
    Collection.find(resource.collection_id)
  end

  def api_key
    organisation_collection = OrganisationCollection.find_by(organisation_id: user.organisation_id, collection_id: resource.collection_id) unless user.nil?
    organisation_collection.api_key if organisation_collection
  end
end
