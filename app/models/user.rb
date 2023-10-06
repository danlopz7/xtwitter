class User < ApplicationRecord

    PASSWORD_REGEX = /(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+])/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    has_many :tweets, dependent: :destroy
    has_many :retweets, class_name: 'Tweet', foreign_key: 'user_id'

    # registros donde este user es el seguidor, follower_id, accion de seguir a un user
    has_many :following_relations, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
    # followings, registros donde se busca a quienes sigue este usuario
    has_many :followees, through: :following_relations, source: :followee

    # registros donde este user es el seguido, followee_id, accion de ser seguido por un user
    has_many :follower_relations, class_name: 'Follow', foreign_key: 'followee_id', dependent: :destroy
    # followers, registros donde se busca quienes siguen a este usuario
    has_many :followers, through: :follower_relations, source: :follower

    has_many :likes, dependent: :destroy
    has_many :liked_tweets, through: :likes, source: :tweet

    #has_many :bookmarks, dependent: :destroy
    has_many :bookmarks, inverse_of: :user

    has_many :replies, dependent: :destroy

    #validates :email, presence: true, uniqueness: { case_sensitive: false }
    validates :username, presence: true, uniqueness: { case_sensitive: false }
    validates :password, length: { minimum: 12 }, format: { with: PASSWORD_REGEX, message: "must include at least 
    1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character like !@/*-+_"}
    
      
    # Method to check if the user has retweeted a tweet
    def has_retweeted?(tweet)
        retweets.exists?(retweet_id: tweet.id)
    end

    # Method to check if the user has liked a tweet
    def has_liked?(tweet)
        liked_tweets.exists?(tweet.id)
    end

    # Method to check if the user has bookmarked a tweet
    def has_bookmarked?(tweet)
        bookmarks.exists?(tweet.id)
    end

    #Scopes
    # Scope to retrieve the number of followers a user has. "Filtra los registros donde el usuario es el seguido (followee)
    scope :followers_count, ->(user_id) { Follow.where(followee_id: user_id).count }

    # Scope to retrieve the number of users a user follows
    scope :following_count, ->(user_id) { Follow.where(follower_id: user_id).count }
end
