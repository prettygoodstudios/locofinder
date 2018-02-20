class AddProfileToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :profile_img, :string
    add_column :users, :bio, :string
  end
end
