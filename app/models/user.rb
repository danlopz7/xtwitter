class User < ApplicationRecord

    PASSWORD_REGEX = /(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+])/

    has_many :tweets, dependent: :destroy
    has_many :bookmarks
    has_many :likes
    has_many :replies

    has_many :followers, foreign_key: :followee_id, class_name: 'Follow', dependent: :destroy
    has_many :followings, foreign_key: :follower_id, class_name: 'Follow', dependent: :destroy
    
    has_many :retweets, class_name: 'Tweet', foreign_key: 'user_id'
    has_many :liked_tweets, through: :likes, source: :tweet

    validates :email, presence: true, uniqueness: true
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 12 }
    validates :password, format: { with: PASSWORD_REGEX, message: "must include at least 
    1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character like !@/*-+_"}

    # Method to check if the user has retweeted a tweet
    def has_retweeted?(tweet)
        retweets.exists?(retweet_id: tweet.id)
    end

    # Method to check if the user has liked a tweet
    def has_liked?(tweet)
        liked_tweets.exists?(tweet.id)
    end

    #Scopes
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

    # Scope that retrieves the bookmarked tweets by a user
    scope :bookmarked_tweets, ->(user_id) do
        joins(:bookmarks)
        .joins("INNER JOIN tweets ON bookmarks.tweet_id = tweets.id")
        .where(bookmarks: { user_id: user_id })
    end
end
