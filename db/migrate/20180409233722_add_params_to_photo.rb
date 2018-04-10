class AddParamsToPhoto < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :width, :integer
    add_column :photos, :height, :integer
    add_column :photos, :zoom, :float
    add_column :photos, :offsetX, :integer
    add_column :photos, :offsetY, :integer
  end
end
