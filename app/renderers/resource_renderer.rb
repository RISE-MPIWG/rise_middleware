class ResourceRenderer < Renderer
  def self.xml(resource)
    doc = create_doc_xml('resource')

    # creating nodes for resource, can be extended
    doc.root << create_node('uuid', resource.uuid.to_s)
    doc.root << create_node('name', resource.name)
    doc.root << create_node('collection', resource.collection.name)
    doc.root << create_node('organisation', resource.organisation.name)

    # metadata
    doc.root << (metadata = create_node('metadata'))

    resource.metadata.each do |key, value|
      metadata << create_node(key, value)
    end

    #sections

    doc.root << (sections = create_node('sections', nil, 'array'))
    sections << create_node('sections_count', resource.sections.count)

    resource.sections.each do |section|
      sections << (node_section = create_node('section'))

      #creating nodes for section, can be extended
      node_section << create_node('uuid', section.uuid)
      node_section << create_node('name', section.name)
      node_section << create_node('uri', section.uri)

      #creating content_units for section, can be extended
      node_section << (content_units = create_node('content_units', nil, 'array'))
      content_units << create_node('content_units_count', section.content_units.count)

      section.content_units.each do |content_unit|
        content_units << (node_content_unit = create_node('content_unit'))
        node_content_unit << create_node('uuid', content_unit.uuid)
        node_content_unit << create_node('content', content_unit.content)
      end
    end
    doc.to_s
  end
end
