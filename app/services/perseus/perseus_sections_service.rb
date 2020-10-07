class PerseusSectionsService
  require 'natural_sort'

  attr_reader :resource, :client

  def self.get_sections(resource)
    new(resource).get_sections
  end

  def initialize(resource)
    @resource = resource
  end

  def get_sections
    sections_xml = fetch_sections_xml(resource)
    parsed_sections = parse_sections_xml(sections_xml)
    transformed_sections = transform_sections(parsed_sections)
    sorted_sections = sort_sections(transformed_sections)
    save_sections(sorted_sections)
  end

  def fetch_sections_xml(resource)
    request = Typhoeus::Request.new(resource.uri, followlocation: true)
    request.run
    sections_xml = request.response.response_body
  end

  def parse_sections_xml(doc)
    parsed_xml = Nokogiri::XML(doc)
    parsed_sections = []
    parsed_xml.css('contents > chunk').each do |chunk|
      title = chunk.css("head[lang='greek']").any? ? BetaCode.beta_code_to_greek(chunk.css('head')[0].text.strip) : chunk.css('head')[0].text.strip
      parsed_sections << {
        title: title,
        uri: 'http://www.perseus.tufts.edu/hopper/xmlchunk?doc=' + chunk['ref']
      }
    end
    parsed_sections
  end

  def transform_sections(parsed_sections)
    transformed_sections = []
    parsed_sections.each do |parsed_section|
      transformed_sections << {
        resource_id: resource.id,
        name: parsed_section[:title],
        uri: parsed_section[:uri]
      }
    end
    transformed_sections
  end

  def sort_sections(transformed_sections)
    transformed_sections.sort { |a, b| NaturalSort.comparator(a[:name], b[:name]) }
  end

  def save_sections(sorted_sections)
    ActiveRecord::Base.transaction do
      Section.import(sorted_sections)
    end
  end
end
