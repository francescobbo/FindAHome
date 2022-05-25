class SetDefaults < ActiveRecord::Migration[6.1]
  def change
    change_column :properties, :ups, :integer, default: 0
    change_column :properties, :downs, :integer, default: 0
  end
end
