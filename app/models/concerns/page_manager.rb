module Concerns
  module PageManager
    extend ActiveSupport::Concern

    included do
      rails_admin do
        list do
          field :name
          field :content
        end

        edit do
          field :name
          field :content, :froala do
            config_options do
              {
                toolbarButtons: %w(bold italic underline insertLink undo redo),
                toolbarButtonsMD: %w(bold italic underline insertLink undo redo),
                toolbarButtonsSM: %w(bold italic underline insertLink undo redo),
                toolbarButtonsXS: %w(bold italic underline insertLink undo redo)
              }
            end
          end
        end
      end
    end
  end
end
