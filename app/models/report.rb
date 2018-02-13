class Report < ApplicationRecord
  has_many :reviews
  has_many :photos
  has_many :locations
  validate :message_length
  def what_type
    retVal = ""
    if review_id != nil
      retVal = "review"
    elsif photo_id != nil
      retVal = "photo"
    elsif location_id != nil
      retVal = "location"
    end
  end
  def user
    retVal = nil
    if what_type == "review"
      retVal = User.find(Review.find(review_id).user_id)
    elsif what_type == "photo"
      retVal = User.find(Photo.find(photo_id).user_id)
    elsif what_type == "location"
      retVal = User.find(Location.find(location_id).user_id)
    end
  end
  def link
    retVal = nil
    if what_type == "review"
      retVal = Location.find(Review.find(review_id).location_id)
    elsif what_type == "photo"
      retVal = Photo.find(photo_id)
    elsif what_type == "location"
      retVal = Location.find(location_id)
    end
  end
  def message_length
    if message.length < 6
      errors.add(:message,"Your message must be atleast six characters long.")
    end
  end
end
