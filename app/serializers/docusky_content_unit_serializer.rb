class DocuskyContentUnitSerializer < ApplicationSerializer
  attributes :corpus, :files

  def corpus
    'corpus'
  end

  def files
    'files'
  end
end
