class ResourceWithSectionsSerializer < ActiveModel::Serializer
  attributes :uuid, :name, :collection_uuid, :uri, :sections

  def sections
    sections_range = object.sections.arrange(order: :id)
    build_json_tree sections_range
  end

  def build_json_tree(nodes)
    nodes.map do |node, sub_nodes|
      { name: node.name, id: node.id, uuid: node.uuid, children: build_json_tree(sub_nodes).compact }
    end
  end
end
