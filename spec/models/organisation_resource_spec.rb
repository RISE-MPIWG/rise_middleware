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

require 'rails_helper'

RSpec.describe OrganisationResource, type: :model do
  it { is_expected.to belong_to(:organisation) }
  it { is_expected.to belong_to(:resource) }
end
