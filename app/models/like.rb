class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  # Validations
  validates :tweet_id, uniqueness: { scope: :user_id, message: "You've already liked this tweet." }

  # Association Validations
  validates_associated :user, :tweet
end
