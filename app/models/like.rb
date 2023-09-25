class Like < ApplicationRecord
    belongs_to :user, class_name: 'User'
    belongs_to :tweet, class_name: 'Tweet'

    validates :tweet_id, :user_id, uniqueness: true
end
