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

require 'rails_helper'

RSpec.describe ContentUnit, type: :model do
  it { is_expected.to belong_to(:section).inverse_of(:content_units) }
end
