# == Schema Information
#
# Table name: organisation_resources
#
#  id              :bigint(8)        not null, primary key
#  organisation_id :bigint(8)
#  resource_id     :bigint(8)
#  access_right    :integer
#  acl             :jsonb
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class OrganisationResource < ApplicationRecord
  belongs_to :organisation
  belongs_to :resource
end
