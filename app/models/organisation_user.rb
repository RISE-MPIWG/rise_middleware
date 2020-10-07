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

class OrganisationUser < ApplicationRecord
  belongs_to :organisation
  belongs_to :user
end
