class CreateMarkers < ActiveRecord::Migration[7.1]
  def change
    create_table :markers do |t|
      t.string :name
      t.text :content
      t.text :enigma
      t.boolean :found
      t.float :radius
      t.float :latitude
      t.float :longitude
      t.string :address

      t.timestamps
    end
  end
end
