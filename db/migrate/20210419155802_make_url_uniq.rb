class MakeUrlUniq < ActiveRecord::Migration[6.1]
  def change
    add_index :properties, :url, unique: true
  end
end
