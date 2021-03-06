# == Schema Information
#
# Table name: resources
#
#  id                :bigint(8)        not null, primary key
#  created_by_id     :integer
#  uuid              :uuid             not null
#  original_uuid     :string           default("")
#  remote_updated_at :datetime
#  collection_id     :bigint(8)
#  name              :string
#  uri               :string
#  contents          :jsonb
#  metadata          :jsonb
#  archived          :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ResourceSerializer < ApplicationSerializer
  attributes :uuid, :name, :collection_uuid, :uri
end
