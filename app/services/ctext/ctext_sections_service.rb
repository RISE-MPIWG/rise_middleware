class CtextSectionsService
  attr_reader :resource, :client, :api_key, :user
  BASE_URL = 'http://api.ctext.org/'.freeze

  def self.get_sections(resource, api_key)
    new(resource, api_key).get_sections
  end

  def initialize(resource, api_key)
    @api_key = api_key
    @resource = resource
    @client = CtextClient.new(@resource.collection.api_url, api_key)
  end

  def get_sections
    sections = fetch_sections
    transformed_sections = transform_sections sections
    save_sections transformed_sections
  end

  def fetch_sections
    response = client.fetch_sections(resource.uri)

    sections = []

    if response['subsections'].present?
      sections = build_tree(response['subsections'])
    else
      sections.push(
        uri: resource.uri,
        title: response['title']
      )
    end

    sections
  end

  def tree(response)
    if response[:response]['subsections'].present?
      subsections = response[:response]['subsections']
      responses = @client.fetch_sections_parallel(subsections, "gettext?urn=")

      section = {
        title: response[:response]['title'],
        uri: response[:uri]
      }

      section[:subsections] = responses.map { |response| tree(response) }

      section
    else
      section = {
        title: response[:response]['title'],
        uri: response[:uri]
      }
      section
    end
  end

  def build_tree(subsections)
    responses = @client.fetch_sections_parallel(subsections, "gettext?urn=")

    sections = []

    responses.each do |response|
      sections.push(tree(response))
    end

    sections
  end

  def transform_sections(sections)
    transformed_sections = []
    sections.each do |section|
      transformed_sections << {
        name: section[:title],
        uri: section[:uri],
        resource_id: resource.id
      }
    end
    transformed_sections
  end

  def save_sections(transformed_sections)
    Section.import transformed_sections
  end
end
