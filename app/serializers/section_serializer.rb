# == Schema Information
#
# Table name: sections
#
#  id                   :bigint(8)        not null, primary key
#  resource_id          :bigint(8)
#  uuid                 :uuid             not null
#  name                 :string
#  uri                  :string
#  original_parent_uuid :string
#  original_uuid        :string
#  metadata             :jsonb
#  ancestry             :string
#  is_leaf              :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class SectionSerializer < ActiveModel::Serializer
  attributes :uuid, :name, :parent_uuid, :uri, :content_unit_count

  def content_unit_count
    @instance_options[:content_unit_count]
  end

end
