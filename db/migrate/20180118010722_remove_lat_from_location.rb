class RemoveLatFromLocation < ActiveRecord::Migration[5.1]
  def change
    remove_column :locations, :lat, :float
    remove_column :locations, :long, :float
  end
end
