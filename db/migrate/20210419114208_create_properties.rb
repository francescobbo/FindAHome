class CreateProperties < ActiveRecord::Migration[6.1]
  def change
    create_table :properties do |t|
      t.string :source
      t.text :url
      t.string :agency
      t.integer :sqm
      t.integer :rpm
      t.integer :bedrooms
      t.integer :bathrooms
      t.float :latitude
      t.float :longitude
      t.integer :ups
      t.integer :downs
      t.text :comment
      t.text :description
      t.boolean :garden
      t.text :images
      t.text :plan
      t.date :available
      t.string :prop_type
      t.string :furnish
      t.text :listing_history
      t.text :stations
      t.text :address
      t.text :key_features

      t.timestamps
    end
  end
end
