class Hashtag < ApplicationRecord
    has_many :taggings
    has_many :tweets, through: :taggings

    validates :name, presence: true
end
