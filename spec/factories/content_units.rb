# == Schema Information
#
# Table name: content_units
#
#  id          :bigint(8)        not null, primary key
#  section_id  :bigint(8)
#  uuid        :uuid             not null
#  resource_id :bigint(8)
#  metadata    :jsonb
#  name        :string
#  content     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :content_unit do
    uuid { SecureRandom.uuid }
    section
    name { Faker::Book.title }
    content { "別集類三{{宋}}提要" }
    trait(:with_metadata) {
      association :section, :with_metadata
      metadata {
        {
          "author" => "Diogenes",
          "language" => "grc",
          "content_unit_level_field" => "content unit"
        }
      }
    }
  end
end
