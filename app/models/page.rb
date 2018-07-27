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
#

class Page < ApplicationRecord
  include Concerns::PageManager
  validates :name, :language, :category, :content, presence: true

  def self.categories
    @categories ||= %w[other about information].freeze
  end
end
