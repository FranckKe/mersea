class AddShoreLengthToReports < ActiveRecord::Migration[5.2]
  def change
    add_column :reports, :shore_length, :integer
  end
end
