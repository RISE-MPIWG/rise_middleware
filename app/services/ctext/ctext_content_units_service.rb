class CtextContentUnitsService
  attr_reader :client, :section, :api_key

  def self.get_content_units(section, api_key)
    new(section, api_key).get_content_units
  end

  def initialize(section, api_key)
    @section = section
    @api_key = api_key
    @client = CtextClient.new(@section.resource.collection.api_url, api_key)
  end

  def get_content_units
    content_units = client.fetch_content_units(section.uri)['fulltext']
    transformed_content_units = transform_content_units(content_units)
    # save_content_units(transformed_content_units)
  end

  def transform_content_units(content_units)
    transformed_content_units = []
    content_units.each do |content_unit|
      transformed_content_units << {
        content: content_unit,
        section_id: section.id
      }
    end
    transformed_content_units
  end

  def save_content_units(transformed_content_units)
    ContentUnit.import transformed_content_units
  end
end
