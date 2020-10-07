# == Schema Information
#
# Table name: organisations
#
#  id                             :bigint(8)        not null, primary key
#  created_by_id                  :integer
#  name                           :string
#  slug                           :string
#  api_url                        :string
#  api_mapping_module             :integer          default("no_mapping_module")
#  saml_issuer_uri                :string
#  api_key                        :string
#  organisation_type              :integer
#  archived                       :boolean          default(FALSE)
#  default_collection_access_type :integer          default("private_access")
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

FactoryBot.define do
  factory :organisation do
    name { Faker::University.name }
    sequence(:slug) { |n| "org_slug_#{n}" }
    saml_issuer_uri { Faker::Internet.url }
    organisation_type { ['research_institute', 'university', 'library', 'vendor'].sample }
  end
end
