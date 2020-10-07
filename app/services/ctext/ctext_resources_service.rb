class CtextResourcesService
  attr_reader :client, :collection
  BASE_URL = 'http://api.ctext.org/'.freeze

  def self.refresh_resources(collection)
    new(collection).refresh_resources
  end

  def initialize(collection)
    @collection = collection
    @client = CtextClient.new(@collection.api_url)
  end

  def refresh_resources
    collection.clear_resources!
    parsed_resources = get_resources
    transformed_resources = transform_resources(parsed_resources)
    resources_with_metadata = add_metadata(transformed_resources)
    save_resources(resources_with_metadata)
  end

  def get_resources
    client.fetch_resources
  end

  def transform_resources(parsed_resources)
    transformed_resources = []
    parsed_resources.fetch("books").each do |resource|
      transformed_resources << {
        collection_id: collection.id,
        name: resource['title'],
        uri: resource['urn']
      }
    end
    transformed_resources
  end

  def save_resources(resources_with_metadata)
    ActiveRecord::Base.transaction do
      Resource.import(resources_with_metadata, validate: false, batch_size: 200)
    end
  end

  def add_metadata(transformed_resources)
    @client.fetch_metadata_parallel(transformed_resources, "gettextinfo?urn=")
  end
end
