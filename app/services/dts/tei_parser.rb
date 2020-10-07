class TeiParser
  def initialize(xml, section)
    @xml = xml
    @section = section
  end

  def parse_xml
    content_units = parse_content_units(@xml)
    transform_content_units(content_units)
  end

  def parse_content_units(xml)
    parsed_content_units_xml = Nokogiri::XML(xml)
    new_content_units = []
    file = parsed_content_units_xml.to_xml
    json = Hash.from_xml(file).to_json
    new_content_units << {
      contents: json
    }
    new_content_units
  end

  def transform_content_units(content_units)
    transformed_content_units = []
    content_units.each do |content_unit|
      transformed_content_units << {
        section_id: @section.id,
        content: content_unit[:contents]
      }
    end
    transformed_content_units
  end

end
