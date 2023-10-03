class Bookmark < ApplicationRecord
  belongs_to :user, inverse_of: :bookmarks
  belongs_to :tweet, inverse_of: :bookmarks

  validates :user_id, presence: true
  validates :tweet_id, presence: true

  # Association Validations
  validates_associated :user, :tweet
  
  # Validations
  validates :tweet_id, uniqueness: { scope: :user_id }

  # Scope to retrieve bookmarks made by a user
  scope :user_bookmarks, ->(user_id) { where(user_id: user_id) }
end
