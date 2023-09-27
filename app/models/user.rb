class User < ApplicationRecord

    PASSWORD_REGEX = /(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+])/

    has_many :tweets, dependent: :destroy
    has_many :retweets, class_name: 'Tweet', foreign_key: 'user_id'
    has_many :following_relations, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
    has_many :followees, through: :following_relations, source: :followee

    has_many :follower_relations, class_name: 'Follow', foreign_key: 'followee_id', dependent: :destroy
    has_many :followers, through: :follower_relations, source: :follower

    has_many :likes, dependent: :destroy
    has_many :liked_tweets, through: :likes, source: :tweet

    has_many :bookmarks, dependent: :destroy
    has_many :replies, dependent: :destroy

    validates :email, presence: true, uniqueness: { case_sensitive: false }
    validates :username, presence: true, uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 12 }, format: { with: PASSWORD_REGEX, message: "must include at least 
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
        joins(:follower_relations).where(followers: { followee_id: user_id }).count
    end

    # Scope to retrieve the number of users a user follows
    scope :following_count, ->(user_id) do
        joins(:following_relations).where(following: { follower_id: user_id }).count
    end

    # Scope that retrieves the bookmarked tweets by a user
    scope :bookmarked_tweets, ->(user_id) do
        joins(:bookmarks)
        .joins("INNER JOIN tweets ON bookmarks.tweet_id = tweets.id")
        .where(bookmarks: { user_id: user_id })
    end
end
