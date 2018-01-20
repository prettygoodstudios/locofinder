class Review < ApplicationRecord
  belongs_to :location
  validate :score, :message, :one_review_per_user, :score_range, :message_length
  def one_review_per_user
    multiple = false
    puts user_id
    Location.all.each do |l|
      l.reviews.each do |r|
        if user_id == r.user_id and location_id == r.location_id
          multiple = true
        end
      end
    end
    if multiple
      errors.add(:user_id, "A user may not leave multiple reviews on a location.")
    end
  end
  def score_range
    if !(score > 0 and score < 11)
      errors.add(:score, "Your score must be an integer between 1 and 10.")
    end
  end
  def message_length
    if !(message.length > 6 and message.length < 300)
      errors.add(:message,"The length of your message must be between 6 and 300 characters.")
    end
  end
end
