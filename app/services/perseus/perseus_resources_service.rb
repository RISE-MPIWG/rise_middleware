class PerseusResourcesService
  PERSEUS_URL = 'http://www.perseus.tufts.edu/hopper/xmltoc?doc='.freeze
  PERSEUS_CATALOG_URL = 'https://raw.githubusercontent.com/PerseusDL/catalog_data/master/perseus/perseuscts.xml'.freeze

  attr_reader :client, :collection

  def self.refresh_resources(collection)
    new(collection).refresh_resources
  end

  def initialize(collection)
    @collection = collection
  end

  def refresh_resources
    parsed_resources = get_resources
    transformed_resources = transform_resources(parsed_resources)
    save_resources(transformed_resources)
  end

  def get_resources
    parsed_xml = Nokogiri::XML(open(PERSEUS_CATALOG_URL))
    resources = []
    parsed_xml.css("textgroup").each do |textgroup|
      textgroup.css('work').each do |work|
        next if work.css('online').first['docname'] == '1999.02.0060.xml'

        resources << {
          name: "#{textgroup.css('groupname').text}, '#{work.css('title').text}'",
          uri:  PERSEUS_URL + work['urn'],
          metadata: {
            dublincore: {
              creator: textgroup.css('groupname').text,
              language: work['xml:lang'],
              description: work.css('description').first.text
            }
          }
        }
      end
    end
    resources
  end

  def transform_resources(resources)
    transformed_resources = []
    resources.each do |resource|
      transformed_resources << {
        name: resource[:name],
        collection_id: @collection.id,
        uri: resource[:uri],
        metadata: resource[:metadata]
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
