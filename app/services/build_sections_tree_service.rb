require 'natural_sort'

class BuildSectionsTreeService
  attr_reader :resource

  def self.tree(resource)
    new(resource).tree
  end

  def initialize(resource)
    @resource = resource
  end

  def tree
    sections_range = resource.sections.arrange(order: :id)
    build_json_tree sections_range
  end

  def build_json_tree(nodes)
    nodes.map do |node, sub_nodes|
      icon = node.childless? ? "far fa-file-alt" : "far fa-folder"
      { text: node.name, id: node.id, uuid: node.uuid, children: build_json_tree(sub_nodes).compact, ancestors: node.ancestors.map(&:name), is_leaf: node.childless?, icon: icon }
    end
  end
end
