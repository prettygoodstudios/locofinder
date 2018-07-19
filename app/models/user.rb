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
  validate :has_profile, :has_bio, :has_display
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
    users.first(10)
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
  def has_display
    if display == nil || display.length < 3
      errors.add(:display,"Your display name must be atleast 3 characters long.")
    end
  end
end
