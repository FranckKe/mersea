class AddUserRelationshipToReports < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :reports, :user, type: :uuid, index: true
  end
end
