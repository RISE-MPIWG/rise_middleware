# == Schema Information
#
# Table name: user_resources
#
#  id           :bigint(8)        not null, primary key
#  user_id      :bigint(8)
#  resource_id  :bigint(8)
#  access_right :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :user_resource do
    user
    resource
    access_right { %i{not_requested requested read write read_write mine}.sample }
  end
end
