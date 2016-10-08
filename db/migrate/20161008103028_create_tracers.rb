class CreateTracers < ActiveRecord::Migration[5.0]
  def change
    create_table :tracers, id: :uuid do |t|
      t.string :name
      t.text :description
      t.attachment :photo
      t.string :origin
      t.string :type
      t.float :longitude
      t.float :latitude

      t.timestamps
    end
  end
end
