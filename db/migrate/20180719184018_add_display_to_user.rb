class AddDisplayToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :display, :string
  end
end
