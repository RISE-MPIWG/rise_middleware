class StandardSectionsService

  attr_reader :resource, :client, :headers, :user

  def self.get_sections(resource, api_key)
    new(resource, api_key).get_sections
  end

  def initialize(resource, api_key)
    @resource = resource
    @api_key = api_key
    @client = StandardClient.new(@resource.collection.api_url, api_key)
  end

  def get_sections
    clear_sections
    sections = client.fetch_sections(resource.original_uuid)
    transformed_sections = transform_sections(sections)
    save_sections(transformed_sections)
    build_sections_hierarchy
  end

  def transform_sections(sections)
    new_sections = []
    sections.each do |section|
      new_sections << {
        resource_id: resource.id,
        name: section['name'] || section['title'],
        original_uuid: section['id'] || section['uuid'],
        original_parent_uuid:  section['parentId'] || section ['parentUuid'],
        uri:  "#{resource.collection.api_url}sections/#{section['id'] || section['uuid']}"
      }
    end
    new_sections
  end


  def save_sections(sorted_sections)
    Section.import(sorted_sections)
  end

  def build_sections_hierarchy
    resource.sections.each do |section|
      next unless section.original_parent_uuid.present?

      section.parent = Section.find_by(original_uuid: section[:original_parent_uuid])
      section.save
    end
  end

  # TODO: also delete content_units or at least check they get deleted too, silly!
  def clear_sections
    Section.joins(:content_units).where(resource_id: resource.id).delete_all
  end
end
