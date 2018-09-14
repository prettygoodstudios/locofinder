class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.integer :user_id
      t.string :authentication_token
      t.datetime :created_at

      t.timestamps
    end
  end
end
