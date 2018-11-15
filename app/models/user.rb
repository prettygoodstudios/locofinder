class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  extend FriendlyId
  require "mini_magick"
  friendly_id :slug_candidates, use: :slugged
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :reviews, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :locations
  has_many :sessions
  mount_uploader :profile_img, ProfileUploader
  serialize :profile_img, JSON
  validate :has_profile, :has_bio, :has_display

<<<<<<< HEAD
=======
  def slug_candidates
    [
      :display,
      [:display, :email],
      [:display, :email, :bio]
    ]
  end

>>>>>>> master
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

  def self.authenticate_via_token email, token
    session = Session.where("authentication_token = '#{token}' AND age(created_at) < '0 years 0 months 1 days'").first
    user = session ? User.find(session.user_id) : false
    user.email == email if user
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
      errors.add(:bio,"is missing");
    end
  end
  def has_profile
    if profile_img == nil
      errors.add(:profile_img, "is missing")
    end
  end
  def has_display
    if display == nil || display.length < 3
      errors.add(:display,"must be atleast 3 characters long")
    end
  end
end
