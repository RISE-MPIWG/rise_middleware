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

require 'rails_helper'

RSpec.describe OrganisationCollection, type: :model do
  it { is_expected.to belong_to(:organisation).inverse_of(:organisation_collections) }
  it { is_expected.to belong_to(:collection).inverse_of(:organisation_collections) }
end
