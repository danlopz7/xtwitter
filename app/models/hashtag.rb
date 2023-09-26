class Hashtag < ApplicationRecord
    has_and_belongs_to_many :tweets

    # Validations
    validates :name, presence: true

    # Association Validations
    # validates_associated :tweets
    # no tiene validates_associated porque la validez de un hashtag 
    # no está vinculada a los tweets que lo contienen, y viceversa.
end
