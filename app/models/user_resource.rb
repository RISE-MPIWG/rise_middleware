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

class UserResource < ApplicationRecord
  belongs_to :user
  belongs_to :resource

  ACCESS_RIGHTS = { not_requested: 0, requested: 1, read: 2, write: 3, read_write: 4, mine: 5 }.freeze
  enum access_right: ACCESS_RIGHTS
end
