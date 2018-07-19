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
        end

        edit do
          field :name
          field :category, :enum do
            enum do
              Page.all.map do |page|
                [page.category, page.category] # e.g. ["English", :en]
              end.uniq
            end
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
