# == Schema Information
#
# Table name: contacts
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  email      :string
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Contact < ApplicationRecord
end
