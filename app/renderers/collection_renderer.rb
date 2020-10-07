class CollectionRenderer < Renderer
  def self.xml(collection)
    doc = create_doc_xml('collection')

    doc.root << create_node('uuid', collection.uuid)
    doc.root << create_node('name', collection.name)
    doc.root << create_node('organisation', collection.organisation.name)
    doc.root << create_node('resources_count', collection.resources.count)

    doc.to_s
  end
end
