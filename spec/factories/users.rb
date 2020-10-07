# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  xasia_token            :string           default(""), not null
#  preferred_language     :integer
#  role                   :integer          default("standard_user")
#  archived               :boolean          default(FALSE)
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  organisation_id        :bigint(8)
#  affiliation            :string
#  name                   :string
#  position               :string
#  auth_token             :string
#  token_created_at       :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  provider               :string
#  uid                    :string
#

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    preferred_language { [nil, :en, :de].sample }
    role { %i{admin standard_user}.sample }
    password { Faker::Internet.password(8) }
    organisation
    trait(:admin) { role { :admin } }
    trait(:with_token) {
      auth_token { SecureRandom.hex }
      token_created_at { Time.zone.now }
    }
  end
end
