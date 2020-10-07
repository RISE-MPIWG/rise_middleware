class DtsCollectionsService

  def self.refresh_collections(organisation_id)
    new(organisation_id).refresh_collections
  end

  def initialize(organisation_id)
    @organisation_id = organisation_id
  end

  def initialize(organisation_id)
    @organisation = Organisation.find(organisation_id)
    @api_url = @organisation.api_url

    @faraday_client = Faraday.new(url: @api_url) do |faraday|
      faraday.response :logger
      faraday.adapter :typhoeus
      faraday.ssl[:verify] = false
      faraday.headers['Content-Type'] = 'application/ld+json'
    end
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

  def refresh_collections
    clear_organisation_cache!(@organisation)
    DtsClient.new(@organisation).get_collections
  end

end
