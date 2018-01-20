class AddLocationToReview < ActiveRecord::Migration[5.1]
  def change
    add_column :reviews, :location_id, :integer
  end
end
