class User < ApplicationRecord
    has_many :tweets
    has_many :bookmarks
    has_many :likes
    has_many :replies
    has_many :followers, foreign_key: 'followee_id', class_name: 'Follower'
    has_many :following, foreign_key: 'follower_id', class_name: 'Follower'

    validates :email, presence: true, uniqueness: true
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 12 }
    #validates :password, format: { with: ^/\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@/*-+_])/}
    #, message: 'must include at least 
    #1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character like !@/*-+_'}

    # Scope to retrieve tweets of a user
    scope :user_tweets, ->(user_id) { joins(:tweets).where(tweets: { user_id: user_id }) }

    # Scope to retrieve tweets and replies of a user
    scope :user_tweets_and_replies, ->(user_id) do
        joins(:tweets, :replies)
            .where("tweets.user_id = ? OR replies.user_id = ?", user_id, user_id)
            .distinct
    end

    # Scope to retrieve the number of followers a user has
    scope :followers_count, ->(user_id) do
        joins(:followers).where(followers: { followee_id: user_id }).count
    end

    # Scope to retrieve the number of users a user follows
    scope :following_count, ->(user_id) do
        joins(:following).where(following: { follower_id: user_id }).count
  end
end
