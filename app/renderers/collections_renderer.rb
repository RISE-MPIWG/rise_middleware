class CollectionsRenderer < Renderer
  def self.xml(collections)
    doc = create_doc_xml('collections')

    doc.root << create_node('collections_count', collections.count)

    collections.each do |collection|
      doc.root << (collection_node  = create_node('collection'))

      collection_node << create_node('name', collection.name)
      collection_node << create_node('uuid', collection.uuid)
      collection_node << create_node('resources_count', collection.resources.count)
    
    end
    doc.to_s
  end
end
