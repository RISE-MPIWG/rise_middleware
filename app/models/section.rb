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

class Section < ApplicationRecord
  include UuidFindable
  include Metadatable
  default_scope { order(:id) }

  has_ancestry

  belongs_to :resource, inverse_of: :sections
  has_many :content_units, inverse_of: :section, dependent: :delete_all

  def content_unit_count
    content_units.count
  end

  def parent_uuid
    if parent.nil?
      nil
    else
      parent.uuid
    end
  end

  def pull_content_units(user)
    RemoteContentUnitsService.refresh_content_units(self, user)
  end
end
