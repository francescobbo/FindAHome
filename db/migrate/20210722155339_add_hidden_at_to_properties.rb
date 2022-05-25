class AddHiddenAtToProperties < ActiveRecord::Migration[6.1]
  def change
    add_column :properties, :hidden_at, :datetime
  end
end
