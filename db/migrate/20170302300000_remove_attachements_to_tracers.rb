class RemoveAttachementsToTracers < ActiveRecord::Migration[5.0]
  def change
    remove_attachment :tracers, :icon_url
  end
end
