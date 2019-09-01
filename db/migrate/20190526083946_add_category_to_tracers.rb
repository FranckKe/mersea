class AddCategoryToTracers < ActiveRecord::Migration[5.2]
  def change
    add_column :tracers, :category, :string
  end
end
