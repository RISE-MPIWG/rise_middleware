# == Schema Information
#
# Table name: sections
#
#  id                   :bigint(8)        not null, primary key
#  resource_id          :bigint(8)
#  uuid                 :uuid             not null
#  name                 :string
#  uri                  :string
#  original_parent_uuid :string
#  original_uuid        :string
#  metadata             :jsonb
#  ancestry             :string
#  is_leaf              :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryBot.define do
  factory :section do
    resource
    uuid { SecureRandom.uuid }
    original_uuid { SecureRandom.uuid }
    name { Faker::Book.title }
    uri { Faker::Internet.url }
    trait :with_content_units do
      after :create do |section|
        create_list :content_unit, 3, section: section
      end
    end
    trait(:with_metadata) {
      association :resource, :with_metadata
      metadata {
        {
          "author" => "Plato",
          "language" => "lat",
          "section_level_field" => "section"
        }
      }
    }
  end
end
