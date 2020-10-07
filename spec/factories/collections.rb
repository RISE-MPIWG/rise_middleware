# == Schema Information
#
# Table name: collections
#
#  id                 :bigint(8)        not null, primary key
#  created_by_id      :integer
#  uuid               :uuid             not null
#  original_uuid      :string
#  resources_url      :string
#  organisation_id    :bigint(8)
#  name               :string
#  slug               :string
#  api_url            :string
#  metadata           :jsonb            not null
#  archived           :boolean          default(FALSE)
#  access_type        :integer          default("private_access")
#  api_mapping_module :integer          default("no_mapping_module")
#  remote_updated_at  :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryBot.define do
  factory :collection do
    organisation
    association :created_by, factory: :user
    uuid { SecureRandom.uuid }
    name { Faker::Book.title }
    trait :with_public_access do
      access_type { 'public_access' }
    end
    api_url { "https://#{Faker::Internet.domain_name}" }
    trait :with_index_and_cache do
      after :create do |collection|
        create_list :resource, 3, :with_sections_with_content_units, collection: collection
      end
    end
    trait :with_metadata do
      metadata {
        {
          "author" => "Latin Authors",
          "language" => "lat",
          "collection_level_field" => "collection"
        }
      }
    end
  end
end
