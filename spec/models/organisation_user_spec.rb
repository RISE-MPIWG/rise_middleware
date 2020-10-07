# == Schema Information
#
# Table name: organisation_users
#
#  id              :bigint(8)        not null, primary key
#  organisation_id :bigint(8)
#  user_id         :bigint(8)
#  role            :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe OrganisationUser, type: :model do
  it { is_expected.to belong_to(:organisation) }
  it { is_expected.to belong_to(:user) }
end
