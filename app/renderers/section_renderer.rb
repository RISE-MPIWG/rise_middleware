class SectionRenderer < Renderer
  def self.xml(section)
    doc = create_doc_xml('section')

    # creating nodes for resource, can be extended
    doc.root << create_node('uuid', section.uuid.to_s)
    doc.root << create_node('name', section.name)


    doc.root << create_node('collection', section.resource.collection.name)
    doc.root << create_node('organisation', section.resource.organisation.name)

    # metadata
    doc.root << (metadata = create_node('metadata'))

    section.resource.metadata.each do |key, value|
      metadata << create_node(key, value)
    end

    # content units
    doc.root << (content_units = create_node('content_units', nil, 'array'))
    content_units << create_node('content_units_count', section.content_units.count)

    section.content_units.each do |content_unit|
      content_units << (node_content_unit = create_node('content_unit'))
      node_content_unit << create_node('uuid', content_unit.uuid)
      node_content_unit << create_node('content', content_unit.content)
    end

    doc.to_s
  end
end
