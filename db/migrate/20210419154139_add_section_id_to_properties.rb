class AddSectionIdToProperties < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :section_id, :integer
  end
end
