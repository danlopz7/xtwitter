class User < ApplicationRecord

  # Relación para los tweets creados por el usuario
  has_many :tweets, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :likes, dependent: :destroy

  # Relación para los seguidores del usuario
  has_many :followers, class_name: 'Follow', foreign_key: 'followee_id'

  # Relación para los usuarios que sigue el usuario
  has_many :followees, class_name: 'Follow', foreign_key: 'follower_id'
  
  #validation for presence and uniqueness for email and username
  validates :email, :username, presence: true, uniqueness: true

  #validates presence for password
  validates :password, presence: true

  #validates password for presence, format and length minimum of 12 chars
  validates :password, presence: true, format: { with: ^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@/*\-+_]).*$}, length: { minimum: 12 }
end
