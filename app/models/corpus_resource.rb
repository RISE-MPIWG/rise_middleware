# == Schema Information
#
# Table name: corpus_resources
#
#  id          :bigint(8)        not null, primary key
#  corpus_id   :bigint(8)
#  resource_id :bigint(8)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CorpusResource < ApplicationRecord
  belongs_to :corpus, inverse_of: :corpus_resources
  belongs_to :resource, inverse_of: :corpus_resources
end
