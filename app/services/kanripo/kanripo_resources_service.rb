class KanripoResourcesService
  attr_reader :client, :collection

  def self.refresh_resources(collection)
    new(collection).refresh_resources
  end

  def initialize(collection)
    @collection = collection
    @client = KanripoClient.new
  end

  def refresh_resources
    parsed_resources = get_resources
    transformed_resources = transform_resources(parsed_resources)
    save_resources(transformed_resources)
  end

  def get_resources
    resources_response = client.fetch_resources
  end

  def transform_resources(parsed_resources)
    transformed_resources = []
    parsed_resources.each do |resource|
      title, dynasty, author = resource.description.split('-')
      transformed_resources << {
        collection_id: collection.id,
        name: title,
        uri:  resource.url,
        metadata: {
          dublincore: {
            creator: author,
            language: 'zh-Hant',
            title: resource.full_name
          },
          extra: {
            dynasty: dynasty
          }
        }
      }
    end
    transformed_resources
  end

  def save_resources(transformed_resources)
    ActiveRecord::Base.transaction do
      Resource.import(transformed_resources, validate: false)
    end
  end
end
