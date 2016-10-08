class CreateReportings < ActiveRecord::Migration[5.0]
  def change
    create_table :reportings, id: :uuid do |t|
      t.string :name
      t.string :email
      t.integer :quantity
      t.string :address
      t.float :longitude
      t.float :latitude
      t.text :description
      t.attachment :photo
      t.timestamp :reported_at

      t.timestamps
    end
  end
end
