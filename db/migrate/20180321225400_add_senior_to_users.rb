class AddSeniorToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :senior, :boolean, default: false
  end
end
