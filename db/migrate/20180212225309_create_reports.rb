class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.string :message
      t.integer :location_id
      t.integer :photo_id
      t.integer :review_id

      t.timestamps
    end
  end
end
