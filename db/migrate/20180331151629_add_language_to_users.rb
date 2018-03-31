class AddLanguageToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :language, :string
    User.update_all language: 'fr'
  end
end
