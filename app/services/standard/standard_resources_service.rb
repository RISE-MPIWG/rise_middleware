class StandardResourcesService
  attr_reader :api_key, :collection, :client

  def self.refresh_resources(collection, api_key = nil)
    new(collection, api_key).refresh_resources
  end

  def initialize(collection, api_key)
    @collection = collection
    @client = StandardClient.new(@collection.api_url, api_key)
  end

  def refresh_resources
    parsed_resources = get_resources
    transformed_resources = transform_resources(parsed_resources)
    resources_with_metadata = add_metadata(transformed_resources)
    save_resources(resources_with_metadata)
  end

  def get_resources
    resources_path = build_resources_path
    client.fetch_resources(resources_path)
  end

  def transform_resources(parsed_resources)
    transformed_resources = []
    parsed_resources.each do |resource|
      transformed_resources << {
        collection_id: collection.id,
        organisation_id: collection.organisation_id,
        original_uuid:  resource['uuid'],
        name: resource['name'],
        uri: "#{collection.api_url}/resources/#{resource['uuid']}"
      }.with_indifferent_access
    end
    transformed_resources
  end

  def build_resources_path
    if collection.original_uuid
      "collections/#{collection.original_uuid}/resources"
    else
      "/resources"
    end
  end

  def add_metadata(transformed_resources)
    @client.fetch_resources_metadata_parallel(transformed_resources, "metadata")
  end

  def save_resources(resources_with_metadata)
    valid_resources = []
    resources_with_metadata.each do |resource|
      if !resource.has_key?('metadata')
        resource[:metadata] = '{}'
      end
      valid_resources << resource
    end
    ActiveRecord::Base.transaction do
      Resource.import(valid_resources, validate: false, batch_size: 200)
    end
  end
end
