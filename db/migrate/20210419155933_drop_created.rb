class DropCreated < ActiveRecord::Migration[6.1]
  def change
    remove_column :properties, :created_at
  end
end
