class AddColorToTracers < ActiveRecord::Migration[5.0]
  def change
    add_column :tracers, :color, :string
  end
end
