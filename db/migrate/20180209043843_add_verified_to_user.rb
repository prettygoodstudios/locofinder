class AddVerifiedToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :verified, :boolean
  end
end
