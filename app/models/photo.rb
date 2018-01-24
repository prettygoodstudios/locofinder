class Photo < ApplicationRecord
  belongs_to :location
  mount_uploader :img_url, PictureUploader
  serialize :img_url, JSON
  validate :caption,:img_url,:has_caption, :has_photo
  def is_mine user
    if user_id == user
      return true
    else
      return false
    end
  end
  def has_caption
    if caption.length < 6 and caption.length > 100
      errors.add(:caption,"Your caption must be atleast six characters long and may not exceed 100 characters in length.")
    end
  end
  def has_photo
    if img_url.url == nil
      errors.add(:img_url,"You must include a photo.")
    end
  end
end
