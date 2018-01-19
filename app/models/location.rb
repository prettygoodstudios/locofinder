class Location < ApplicationRecord
  geocoded_by :full_address
  after_validation :geocode
  def full_address
    addressArray = [country, state, city, address]
    addressArray.compact.join(", ")
  end
end
