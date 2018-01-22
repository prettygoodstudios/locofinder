class AddLocationToPhoto < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :location_id, :integer
  end
end
