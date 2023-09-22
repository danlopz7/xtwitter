class Hashtag < ApplicationRecord
    has_and_belongs_to_many :tweets

    # Validations
    validates :name, presence: true

    # Association Validations
    validates_associated :tweets
end
