class User < ApplicationRecord
    has_many :tweets
    has_many :bookmarks
    has_many :likes
    has_many :replies

    validates :email, presence: true, uniqueness: true
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 12 }
    #validates :password, format: { with: ^/\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@/*-+_])/}
    #, message: 'must include at least 
    #1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character like !@/*-+_'}
end
