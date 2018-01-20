class Location < ApplicationRecord
  geocoded_by :full_address
  after_validation :geocode
  has_many :reviews
  has_many :photos
  belongs_to :user
  def full_address
    addressArray = [country, state, city, address]
    addressArray.compact.join(", ")
  end

  def average_score
    avg_score = 0
    reviews.each do |r|
      avg_score += r.score / reviews.length
    end
    return avg_score
  end
end
