class KanripoSectionsService
  attr_reader :resource, :client

  def self.get_sections(resource)
    new(resource).get_sections
  end

  def initialize(resource)
    @resource = resource
    @client = KanripoClient.new
  end

  def get_sections
    sections = fetch_from_readme
    transformed_sections = transform_sections(sections)
    save_sections(transformed_sections)
  end

  def fetch_from_readme
    readme_url = @client.fetch_readme(resource)
    readme = open(readme_url).read
    html_readme = Orgmode::Parser.new(readme).to_html
    html = Nokogiri::HTML(html_readme)
    contents = []
    html.css('a').each do |link|
      contents << {
        url: link['href'],
        title: link.content.gsub(/\¶/, '')
      }
    end
    contents
  end

  def transform_sections(sections)
    transformed_sections = []
    sections.each do |parsed_section|
      transformed_sections << {
          resource_id: resource.id,
          name: parsed_section[:title],
          uri: @client.octokit_client.contents(resource.metadata['dublincore']['title'], path: parsed_section[:url]).download_url
        }
    end
    transformed_sections
  end

  def save_sections(transformed_sections)
    ActiveRecord::Base.transaction do
      Section.import(transformed_sections)
    end
  end

end
