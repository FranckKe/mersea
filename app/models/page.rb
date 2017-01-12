# == Schema Information
#
# Table name: pages
#
#  id         :uuid             not null, primary key
#  name       :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Page < ApplicationRecord
  include Concerns::PageManager
end
