class RemoteContentUnitsService
  attr_reader :section, :user

  def self.refresh_content_units(section, user = nil)
    new(section, user).refresh_content_units
  end

  def initialize(section, user = nil)
    @section = section
    @user = user
  end

  def refresh_content_units
    collection = find_collection

    case collection.api_mapping_module.to_sym
    when :kanripo
      KanripoContentUnitsService.get_content_units(section)
    when :standard
      StandardContentUnitsService.get_content_units(section, collection, api_key)
    when :ctext
      CtextContentUnitsService.get_content_units(section, api_key)
    when :kanripo
      KanripoContentUnitsService.get_content_units(section)
    when :esukhia
      EsukhiaContentUnitsService.get_content_units(section)
    when :perseus
      PerseusContentUnitsService.get_content_units(section)
    when :dts
      dts = DtsClient.new(collection.organisation)
      dts.get_content_units(section)
    end
  end

  # TODO : we might be able to cache the collection without using find_
  def find_collection
    Collection.find(section.resource.collection_id)
  end

  def api_key
    organisation_collection = OrganisationCollection.find_by(organisation_id: user.organisation_id, collection_id: section.resource.collection_id) unless user.nil?
    organisation_collection.api_key if organisation_collection
  end
end
