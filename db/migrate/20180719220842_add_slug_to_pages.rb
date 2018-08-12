class AddSlugToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :slug, :string
  end
end
