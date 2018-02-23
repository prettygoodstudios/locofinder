class AddOptionsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :zoom, :number
    add_column :users, :width, :integer
    add_column :users, :height, :integer
    add_column :users, :offsetX, :integer
    add_column :users, :offsetY, :integer
  end
end
