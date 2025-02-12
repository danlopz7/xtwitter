class Tweet < ApplicationRecord
  belongs_to :user

  # Self join references
  belongs_to :original_retweet, class_name: 'Tweet', optional: true, foreign_key: 'retweet_id'
  belongs_to :original_quote, class_name: 'Tweet', optional: true, foreign_key: 'quote_id'

  has_many :retweets, class_name: 'Tweet', foreign_key: 'retweet_id', dependent: :destroy
  has_many :quotes, class_name: 'Tweet', foreign_key: 'quote_id', dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  has_many :bookmarks, inverse_of: :tweet

  has_many :replies, class_name: 'Reply', foreign_key: 'tweet_id'
  has_and_belongs_to_many :hashtags
  
  validates :user, presence: true
  validates :content, presence: true, length: { maximum: 255 }, if: -> { tweet_or_quote? }

  def tweet_or_quote?
    retweet_id.nil? || quote_id.present?
  end

  # Method for retweeting
  def retweet(user)
    # Check if the user hasn't already retweeted this tweet
    unless user.has_retweeted?(self)
      # Create a new retweet associated with the user
      retweet = Tweet.new(user_id: user.id, content: self.content, retweet_id: id)
      if retweet.save
        return retweet 
      end
    end
    false # Retweet unsuccessful (e.g., user alresady retweeted)
  end
  
  # Method for quoting a tweet
  def quote_tweet(user, text_body)
    return nil if text_body.blank? # No se permite una cita de tweet vacía

    # Crear un nuevo tweet con el usuario actual como autor y el tweet original como cita
    quote = Tweet.new(user_id: user.id, quote_id: id, content: text_body)
    quote.save ? quote : nil
  end

  # Method for liking a tweet
  def like(user)
    # Check if the user hasn't already liked this tweet
    unless user.has_liked?(self)
      # Create a new like associated with the user
      like = Like.new(user_id: user.id, tweet_id: id)
      if like.save
        return like # Like successful
      end
    end
    false # Like unsuccessful (e.g., user already liked the tweet)
  end

  # Method for bookmark a tweet
  def bookmark(user)
    unless user.has_bookmarked?(self)
      bookmark = Bookmark.new(user_id: user.id, tweet_id: id)
      if bookmark.save
        return bookmark #Bookmark successful
      end
    end
    false # Bookmark unsuccessful (e.g., user already bookmarked the tweet)
  end

  # Method to create hashtags from tweet content
  def create_hashtags_from_content
    return unless content.present?

    hashtag_texts = content.scan(/#\w+/) # Busca palabras que comiencen con '#'
    
    hashtag_texts.each do |text|
      hashtag = Hashtag.find_or_create_by(name: text[1..-1]) # Elimina el '#' del texto
      hashtags << hashtag unless hashtags.include?(hashtag)
    end
  end

  # Scope to retrieve tweets of a user
  scope :user_tweets, ->(user_id) { where(user_id: user_id) }

  # Scope to retrieve the number of users a user follows
  scope :user_tweets_and_replies, ->(user_id) do
    joins("LEFT JOIN replies ON tweets.id = replies.tweet_id")
      .where("tweets.user_id = ? OR replies.user_id = ?", user_id, user_id)
      .distinct
  end

  # Scope to retrieve the number of retweets
  scope :retweets_count, ->(tweet_id) { where(retweet_id: tweet_id).count }
  
  # Scope to retrieve the number of quotes
  scope :quotes_count, ->(tweet_id) { where(quote_id: tweet_id).count }
end
