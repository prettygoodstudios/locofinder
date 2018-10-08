class AddSlugToPhotos < ActiveRecord::Migration[5.1]
  def change
    add_column :photos, :slug, :string
  end
end
