# == Schema Information
#
# Table name: research_tools
#
#  id            :bigint(8)        not null, primary key
#  created_by_id :integer
#  uuid          :uuid             not null
#  name          :string
#  description   :text
#  url           :string
#  slug          :string
#  archived      :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :research_tool do
    uuid { SecureRandom.uuid }
    name { ["MARKUS", "Voyant Tools"].sample }
    association :created_by, factory: :user
    description { Faker::Books::Lovecraft.sentence }
    url { Faker::Internet.url }
    trait :with_example_url do
      name { "Example Research Tool" }
      url { 'https://tool.com' }
    end
  end
end
