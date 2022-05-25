class AddConsiderToSections < ActiveRecord::Migration[6.1]
  def change
    add_column :sections, :consider, :boolean, default: true, null: false
  end
end
