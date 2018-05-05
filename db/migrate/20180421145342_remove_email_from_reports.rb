class RemoveEmailFromReports < ActiveRecord::Migration[5.1]
  def change
    remove_column :reports, :email
  end
end
