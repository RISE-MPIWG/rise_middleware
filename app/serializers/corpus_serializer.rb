# == Schema Information
#
# Table name: corpora
#
#  id            :bigint(8)        not null, primary key
#  created_by_id :integer
#  uuid          :uuid             not null
#  name          :string
#  description   :text
#  archived      :boolean          default(FALSE)
#  privacy_type  :integer          default("private_access")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class CorpusSerializer < ApplicationSerializer
  attributes :uuid, :name, :description
end
