class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  require "mini_magick"
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :reviews, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :locations
  mount_uploader :profile_img, ProfileUploader
  serialize :profile_img, JSON
  validate :has_profile, :has_bio
  def has_a_review location
    found = false
    reviews.each do |r|
      if r.location_id == location
        found = true
      end
    end
    return found
  end
  def self.index_sort
    users = select{ |u| u.has_photos }
    users.sort_by!{ |u| u.cumulative_views }.reverse!
    #users = users.order("Desc cumulative_views")
    users
  end
  def has_photos
    retVal = false
    if photos.length != 0
      retVal = true
    end
    retVal
  end
  def collumns
    cols = 0
    if photos.length > 2
      cols = 3
    elsif photos.length > 1
      cols = 2
    else
      cols = 1
    end
    cols
  end
  def cumulative_views
    retVal = 0
    photos.each do |p|
      retVal += p.views
    end
    retVal
  end
  def has_bio
    if bio == ""
      errors.add(:bio,"You must have a bio.");
    end
  end
  def has_profile
    if profile_img == nil
      errors.add(:profile_img, "You must upload a profile image.")
    end
  end
  def process_image
    img = resize_with_crop(MiniMagick::Image.open(profile_img.url),width.to_f*zoom.to_f,height.to_f*zoom.to_f,offsetX,offsetY)
    return img.path
  end
  def resize_with_crop(img, w, h, w_offset, h_offset)
    w_original, h_original = [img[:width].to_f, img[:height].to_f]
    op_resize = ''
    # check proportions
    if w_original * h < h_original * w
      op_resize = "#{w.to_i}x"
      w_result = w
      h_result = (h_original * w / w_original)
    else
      op_resize = "x#{h.to_i}"
      w_result = (w_original * h / h_original)
      h_result = h
    end
    img.combine_options do |i|
      i.resize(op_resize)
      i.crop "#{w.to_i}x#{h.to_i}+#{w_offset}+#{h_offset}!"
    end
    img
  end
end
