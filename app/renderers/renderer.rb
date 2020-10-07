require 'libxml'

class Renderer
  include LibXML

  def self.create_doc_xml(root)
    doc = LibXML::XML::Document.new
    doc.encoding = LibXML::XML::Encoding::UTF_8
    doc.root = LibXML::XML::Node.new(root)
    doc
  end

  def self.create_node(name, value=nil, type=nil)
    node = LibXML::XML::Node.new(name)
    node.content = value.to_s unless value.nil?
    LibXML::XML::Attr.new(node, 'type', type) unless type.nil?
    node
  end
end
