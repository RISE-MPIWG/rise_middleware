class ContentUnitRenderer < Renderer
  def self.xml(content_unit)
    doc = create_doc_xml('content_unit')

    doc.root << create_node('uuid', content_unit.uuid.to_s)

    # metadata
    doc.root << (metadata = create_node('metadata'))

    content_unit.section.resource.metadata.each do |key, value|
      metadata << create_node(key, value)
    end

    doc.root << create_node('content', content_unit.content)

    doc.to_s
  end
end
