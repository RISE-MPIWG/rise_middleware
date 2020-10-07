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

FactoryBot.define do
  factory :organisation_collection do
    organisation
    collection
    trait(:read_access) { access_right { :read } }
    trait(:mine_access) { access_right { :mine } }
    trait(:with_api_key) { api_key { SecureRandom.hex } }
  end
end
