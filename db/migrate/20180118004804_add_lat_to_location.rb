class AddLatToLocation < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :lat, :float
    add_column :locations, :long, :float
  end
end
