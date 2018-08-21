module Concerns
  module PageManager
    extend ActiveSupport::Concern

    included do
      rails_admin do
        list do
          field :name
          field :language
          field :content
          field :category
          field :slug
        end

        edit do
          field :name
          field :category, :enum do
            enum do
              Page::CATEGORIES.map do |category|
                [I18n.t(category, scope: 'pages.categories', locale: I18n.locale), category]
              end
            end
          end
          field :slug, :slug do
            source 'name'
          end
          field :language, :enum do
            enum do
              I18n.available_locales.map do |lang|
                [I18n.t('.name', locale: lang), lang] # e.g. ["English", :en]
              end
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
                language: I18n.locale
              }
            end
          end
        end
      end
    end
  end
end
