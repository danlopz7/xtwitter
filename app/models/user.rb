class User < ApplicationRecord
  has_many :tweets
  has_many :bookmarks
  has_many :likes
  has_many :replies
  has_many :followed_users, foreign_key: :follower, class_name: Follow
  has_many :followers, through: :followed_users
end
