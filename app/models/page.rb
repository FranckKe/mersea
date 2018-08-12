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
#  category   :string           default("other")
#  slug       :string
#

class Page < ApplicationRecord
  include Concerns::PageManager
  validates :name, :language, :category, :slug, :content, presence: true

  CATEGORIES = %w(other about information).freeze
end
