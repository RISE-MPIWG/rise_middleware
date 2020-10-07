class DocuskySectionSerializer < ApplicationSerializer
  attributes :corpus, :files
  def corpus
    object.title
  end

  def files
    object.content_units.map { |e| { filename: e.title, content: e.contents } }
  end
end
