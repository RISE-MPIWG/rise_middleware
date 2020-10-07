class EsukhiaContentUnitsService
  attr_reader :client, :section

  def self.get_content_units(section)
    new(section).get_content_units
  end

  def initialize(section)
    @section = section
  end

  def get_content_units
    file = open(section.uri).read
    parsed_content_units = file.split("\n")
    content_units = []
    parsed_content_units.each do |parsed_content_unit|
      content_units << {
        section_id: section.id,
        resource_id: section.resource_id,
        content: parsed_content_unit
      }
    end
    content_units
    # ContentUnit.import(content_units)
  end
end
