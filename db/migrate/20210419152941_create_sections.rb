class CreateSections < ActiveRecord::Migration[6.1]
  def change
    create_table :sections do |t|
      t.text :data
      t.text :geojson
      t.date :lastrun

      t.timestamps
    end
  end
end
