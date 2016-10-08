class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports, id: :uuid do |t|
      t.belongs_to :tracer, type: :uuid, index: true

      t.string :name
      t.string :email
      t.integer :quantity
      t.string :address, index: true
      t.float :longitude, index: true
      t.float :latitude, index: true
      t.text :description
      t.attachment :photo
      t.date :reported_at, index: true
      t.date :reported_at, index: true
      t.string :status, index: true

      t.timestamps
    end
  end
end
