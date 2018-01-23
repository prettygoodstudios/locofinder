class Photo < ApplicationRecord
  belongs_to :location
  mount_uploader :img_url, PictureUploader
  serialize :img_url, JSON

  def is_mine user
    if user_id == user
      return true
    else
      return false
    end
  end
end
