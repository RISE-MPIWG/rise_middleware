# == Schema Information
#
# Table name: organisation_collections
#
#  id              :bigint(8)        not null, primary key
#  organisation_id :bigint(8)
#  collection_id   :bigint(8)
#  api_key         :string           default("")
#  access_right    :integer          default("no_access")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class OrganisationCollection < ApplicationRecord
  belongs_to :organisation, inverse_of: :organisation_collections
  belongs_to :collection, inverse_of: :organisation_collections

  ACCESS_RIGHTS = { no_access: 0, read: 1, mine: 2 }.freeze
  enum access_right: ACCESS_RIGHTS
end
