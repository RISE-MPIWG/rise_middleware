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

class Corpus < ApplicationRecord
  include Archivable
  include UuidFindable
  has_many :corpus_resources, inverse_of: :corpus
  has_many :resources, through: :corpus_resources
  has_many :content_units, through: :resources
  belongs_to :created_by, class_name: "User", foreign_key: 'created_by_id', optional: true

  PRIVACY_TYPES = { private_access: 0, public_access: 1 }.freeze
  enum privacy_type: PRIVACY_TYPES

  def to_s
    name
  end

  def pull_full_text(user)
    resources.each do |resource|
      resource.pull_full_text(user)
    end
  end

  def addable_resources
    Resource.active.where.not(id: resources.pluck(:id))
  end
end
