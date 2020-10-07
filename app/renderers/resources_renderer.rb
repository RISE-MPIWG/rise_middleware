class ResourcesRenderer < Renderer
  def self.xml(resources)
    doc = create_doc_xml('resources')

    resources.each do |resource|
      doc.root << (resource_node  = create_node('resource'))

      resource_node << create_node('name', resource.name)
      resource_node << create_node('uuid', resource.uuid)
      resource_node << create_node('collection_uuid', resource.collection.uuid)
      resource_node << create_node('uri', resource.uri)
  end
    doc.to_s
  end
end
