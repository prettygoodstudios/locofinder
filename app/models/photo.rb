class Photo < ApplicationRecord
  belongs_to :location
  mount_uploader :img_url, PictureUploader
  serialize :img_url, JSON
end
