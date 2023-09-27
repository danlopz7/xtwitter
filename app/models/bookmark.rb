class Bookmark < ApplicationRecord
  belongs_to :user, inverse_of: :bookmarks
  belongs_to :tweet, inverse_of: :bookmarks

  validates :user_id, presence: true
  validates :tweet_id, presence: true

  # Association Validations
  validates_associated :user, :tweet

  # Scope to retrieve bookmarks made by a user
  scope :by_user, ->(user_id) { where(user_id: user_id) }
end
