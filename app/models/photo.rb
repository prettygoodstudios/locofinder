class Photo < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  belongs_to :location
  belongs_to :user
  mount_uploader :img_url, PictureUploader
  serialize :img_url, JSON
  validate :caption,:img_url,:has_caption, :has_photo

  def slug_candidates
    [
      :caption,
      [:caption, :img_url]
    ]
  end

  def is_mine user
    if user_id == user
      return true
    else
      return false
    end
  end
  def self.mostViews
    order("views DESC")
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
