class AddIconUrlToTracers < ActiveRecord::Migration[5.0]
  def change
    add_attachment :tracers, :icon_url
  end
end
