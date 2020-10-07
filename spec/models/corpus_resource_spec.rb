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

require 'rails_helper'

RSpec.describe CorpusResource, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
