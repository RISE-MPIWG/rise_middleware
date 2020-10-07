class KanripoContentUnitsService
  attr_reader :client, :section

  def self.get_content_units(section)
    new(section).get_content_units
  end

  def initialize(section)
    @section = section
  end

  def get_content_units
    file = open(section.uri).read
    parsed_content_units = format_txt(file)
    content_units = []
    parsed_content_units.each do |parsed_content_unit|
      content_units << {
        section_id: section.id,
        resource_id: section.resource_id,
        content: parsed_content_unit
      }
    end  
    # ContentUnit.import(content_units)
    content_units
  end

  def format_txt(file)
    formated_txt_file = file.gsub(/\¶/, '')
    html_file = Orgmode::Parser.new(formated_txt_file).to_html
    page = Nokogiri::HTML(html_file)
    page.css('a').each do |item|
      new_node = page.create_element "br"
      item.replace new_node
    end
    parsed_content = page.css('p').inner_html.to_s.gsub(/\n/, '').split('<br>').map {|el| el.strip }.delete_if { |el| el.empty? }
  end

end
