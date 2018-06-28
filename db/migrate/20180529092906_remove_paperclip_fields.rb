class RemovePaperclipFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :tracers, :photo_file_name
    remove_column :tracers, :photo_content_type
    remove_column :tracers, :photo_file_size
    remove_column :tracers, :photo_updated_at

    remove_column :reports, :photo_file_name
    remove_column :reports, :photo_content_type
    remove_column :reports, :photo_file_size
    remove_column :reports, :photo_updated_at
  end
end
