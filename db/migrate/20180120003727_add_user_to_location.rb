class AddUserToLocation < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :user_id, :string
    add_column :locations, :integer, :string
  end
end
