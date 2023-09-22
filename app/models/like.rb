class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  # Validations
  validates :tweet_id, uniqueness: { scope: :user_id }

  # Association Validations
  validates_associated :user, :tweet
end
