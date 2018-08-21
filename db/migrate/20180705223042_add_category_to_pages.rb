class AddCategoryToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :category, :string, default: 'other'
  end
end
