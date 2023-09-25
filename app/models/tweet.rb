class Tweet < ApplicationRecord
  belongs_to :user, class_name: 'User'

  # Relación para el tweet citado (quote) si es una cita
  has_many :quoted_tweet, class_name: 'Tweet', foreign_key: 'quote_id'

  # Relación para los retweets del tweet
  has_many :retweets, class_name: 'Tweet', foreign_key: 'retweet_id'

  # Relación para los Replies (respuestas) a un tweet
  has_many :replies, class_name: 'Reply', foreign_key: 'tweet_id', dependent: :destroy

  has_many :taggings
  has_many :likes

  validates :content, presence: true, length: { maximum: 255 }, unless: -> { retweet? }

  private
  def retweet?
    !retweet_id.nil?
  end

  # unless: -> { retweet? } especifica que estas validaciones solo se aplican si el método retweet? 
  # devuelve false, lo que significa que el tweet no es un retweet. Si es un retweet, las validaciones se omiten.

  validates_associated :replies
  validates_associated :likes
  #validates_associated :hashtags
end