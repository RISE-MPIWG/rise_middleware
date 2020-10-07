class PerseusContentUnitsService
  attr_reader :client, :section

  def self.get_content_units(section)
    new(section).get_content_units
  end

  def initialize(section)
    @section = section
  end

  def get_content_units
    content_units = fetch_content_units(section)
    parsed_content_units = parse_content_units(content_units)
    transformed_content_units = transform_content_units(parsed_content_units)
    # save_content_units(transformed_content_units)
  end

  def fetch_content_units(section)
    request = Typhoeus::Request.new(section.uri, followlocation: true)
    request.run
    request.response.response_body
  end

  def parse_content_units(doc)
    parsed_content_units_xml = Nokogiri::XML(doc)
    new_content_units = []
    if parsed_content_units_xml.css("body > div1[type ='book']").any?
      parsed_content_units_xml.css('div1 > *').each do |parsed_content_unit|
        new_content_units << {
          contents: parsed_content_unit.text
        }
      end
    else
      parsed_content_units_xml.css('p').each do |parsed_content_unit|
        new_content_units << {
          contents: parsed_content_unit.text
        }
      end
    end
    new_content_units
  end

  def transform_content_units(content_units)
    transformed_content_units = []
    content_units.each do |content_unit|
      transformed_content_units << {
        section_id: section.id,
        content: content_unit[:contents]
      }
    end
    transformed_content_units
  end

  def save_content_units(transformed_content_units)
    ActiveRecord::Base.transaction do
      section.content_units.delete_all
      ContentUnit.import(transformed_content_units)
    end
  end
end
