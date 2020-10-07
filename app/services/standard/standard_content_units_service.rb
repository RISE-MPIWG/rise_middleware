class StandardContentUnitsService
  attr_reader :client, :section

  def self.get_content_units(section, collection, api_key)
    new(section, collection, api_key).get_content_units
  end

  def initialize(section, collection, api_key)
    @section = section
    @collection = collection
    @client = StandardClient.new(@collection.api_url, api_key)
  end

  def get_content_units
    content_units = client.fetch_content_units(section.original_uuid)
    transformed_contents_units = transform_content_units(content_units)

    # if section.content_units.empty?
    #   content_units = client.fetch_content_units(section.original_uuid)
    #   transformed_contents_units = transform_content_units(content_units)
    #   save_content_units(transformed_contents_units)
    # else
    #   section.content_units
    # end
  end

  def transform_content_units(content_units)
    new_content_units = []
    if content_units.is_a?(Hash) && content_units[:remote_errors].present?
      content_units = [{
        section_id: section.id,
        title: '',
        content: 'remote_error'
      }]
    end
    content_units.each do |content_unit|
      new_content_units << {
        section_id: section.id,
        name: content_unit['title'],
        content: content_unit['contents'] || content_unit['content']
      }
    end
    new_content_units
  end

  def save_content_units(transformed_content_units)
    ContentUnit.import(transformed_content_units)
  end
end
