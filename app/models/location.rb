class Location < ApplicationRecord
  geocoded_by :full_address
  validate :address, :city, :state, :country, :title, :location_validate
  after_validation :geocode
  has_many :reviews
  has_many :photos
  belongs_to :user
  def full_address
    addressArray = [address, city, state, country]
    addressArray.compact.join(", ")
  end

  def average_score
    avg_score = 0
    reviews.each do |r|
      avg_score += r.score
    end
    if reviews.length != 0
      return avg_score/reviews.length
    else
      return 0
    end
  end
  def location_validate
    if title != ""
      if address != ""
        if city != ""
          if state != ""
            if country != ""

            else
              errors.add(:country,"Country may not be blank.")
            end
          else
            errors.add(:state,"State may not be blank.")
          end
        else
          errors.add(:city,"City may not be blank.")
        end
      else
        errors.add(:country,"Address may not be blank.")
      end
    else
      errors.add(:title,"Title may not be blank.")
    end
  end
end
