class AddStarToProperties < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :star, :boolean, null: false, default: false
  end
end
