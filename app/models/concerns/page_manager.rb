module Concerns
  module PageManager
    extend ActiveSupport::Concern

    included do
      rails_admin do
        list do
          field :name
          field :language
          field :content
        end
        edit do
          field :name
          field :language, :enum do
            enum do
              [
                %w[Français fr],
                %w[English en],
                %w[Español es]
              ]
            end
          end
          field :content, :froala do
            config_options do
              {
                toolbarButtons: [
                  'fullscreen', 'bold', 'italic', 'underline', 'strikeThrough',
                  'subscript', 'superscript', '|',
                  'fontFamily', 'fontSize', 'color', 'inlineStyle',
                  'paragraphStyle', '|',
                  'paragraphFormat', 'align', 'formatOL', 'formatUL', 'outdent',
                  'indent', 'quote', '-', 'insertLink', 'insertImage',
                  'insertVideo', 'insertTable', '|',
                  'emoticons', 'specialCharacters', 'insertHR', 'selectAll',
                  'clearFormatting', '|',
                  'print', 'spellChecker', 'help', 'html', '|',
                  'undo', 'redo'
                ],
                language: 'fr'
              }
            end
          end
        end
      end
    end
  end
end
