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

require 'rails_helper'

RSpec.describe UserResource, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:resource) }
end
