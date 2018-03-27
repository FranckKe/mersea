# == Schema Information
#
# Table name: pages
#
#  id         :uuid             not null, primary key
#  name       :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  language   :string
#

class Page < ApplicationRecord
  include Concerns::PageManager
  validates :name, :language, :content, presence: true
end
