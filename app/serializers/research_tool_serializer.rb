# == Schema Information
#
# Table name: research_tools
#
#  id            :bigint(8)        not null, primary key
#  created_by_id :integer
#  uuid          :uuid             not null
#  name          :string
#  description   :text
#  url           :string
#  slug          :string
#  archived      :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ResearchToolSerializer < ApplicationSerializer
  attributes :uuid, :name, :description, :url
end
