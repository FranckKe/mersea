class AddIconUrlToTracers < ActiveRecord::Migration
  def change
    add_attachment :tracers, :icon_url
  end
end
