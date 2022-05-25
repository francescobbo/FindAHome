class AddIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :properties, :section_id
  end
end
