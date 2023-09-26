class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  # Association Validations
  validates_associated :user, :tweet
end
