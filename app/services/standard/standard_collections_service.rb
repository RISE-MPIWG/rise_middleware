class StandardCollectionsService
  attr_reader :api_key, :organisation, :client

  def self.refresh_collections
    new(collection, api_key).refresh_index
  end

  def initialize(organisation, api_key = nil)
    @organisation = organisation
    @client = StandardClient.new(@organisation.api_url, api_key)
  end

  def refresh_collections
    collections = get_collections
    transformed_collections = transform_collections(collections)
    collections_with_metadata = add_metadata(transformed_collections)
    save_collections(collections_with_metadata)
  end

  def get_collections
    collections_response = client.fetch_collections
  end

  def transform_collections(collections)
    transformed_collections = []
    collections.each do |collection|
      transformed_collections << {
        original_uuid: collection['uuid'],
        organisation_id: @organisation.id,
        name: "#{@organisation.slug.upcase} - #{collection['name']}",
        api_mapping_module: @organisation.api_mapping_module,
        access_type: organisation.default_collection_access_type,
        api_url: @organisation.api_url,
        remote_updated_at: collection['updated_at'],
        resources_url: "#{@organisation.api_url}/#{collection['uuid']}/resources"
      }
    end
    transformed_collections
  end

  def add_metadata(transformed_collections)
    @client.fetch_collections_metadata_parallel(transformed_collections, "metadata")
  end

  def save_collections(collections_with_metadata)
    ActiveRecord::Base.transaction do
      Collection.import(collections_with_metadata, validate: false)
    end
  end
end
