# == Schema Information
#
# Table name: collections
#
#  id                 :bigint(8)        not null, primary key
#  created_by_id      :integer
#  uuid               :uuid             not null
#  original_uuid      :string
#  resources_url      :string
#  organisation_id    :bigint(8)
#  name               :string
#  slug               :string
#  api_url            :string
#  metadata           :jsonb            not null
#  archived           :boolean          default(FALSE)
#  access_type        :integer          default("private_access")
#  api_mapping_module :integer          default("no_mapping_module")
#  remote_updated_at  :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class CollectionSerializer < ApplicationSerializer
  attributes :uuid, :name, :resource_count
end
