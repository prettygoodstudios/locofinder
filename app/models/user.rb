class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :reviews, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :locations

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
    users.sort_by{ |u| u.photos.length }
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
  def cumulative_views
    retVal = 0
    photos.each do |p|
      retVal += p.views
    end
    retVal
  end
end
