class AddLanguageToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :language, :string
    Page.update_all language: 'fr'
  end
end
