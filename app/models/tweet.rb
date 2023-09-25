class Tweet < ApplicationRecord
  belongs_to :user

  has_many :retweets, class_name: 'Tweet', foreign_key: 'retweet_id', dependent: :destroy
  has_many :quote_tweets, class_name: 'Tweet', foreign_key: 'quote_id', dependent: :destroy
  has_many :replies, class_name: 'Reply', foreign_key: 'tweet_id'
  has_many :bookmarks
  has_many :likes
  
  has_and_belongs_to_many :hashtags
  
  # Method for retweeting
  def retweet(user)
    # Check if the user hasn't already retweeted this tweet
    unless user.has_retweeted?(self)
      # Create a new retweet associated with the user
      retweet = Tweet.new(user_id: user.id, retweet_id: id)
      if retweet.save
        return true # Retweet successful
      end
    end
    false # Retweet unsuccessful (e.g., user already retweeted)
  end

  # Method for liking a tweet
  def like(user)
    # Check if the user hasn't already liked this tweet
    unless user.has_liked?(self)
      # Create a new like associated with the user
      like = Like.new(user_id: user.id, tweet_id: id)
      if like.save
        return true # Like successful
      end
    end
    false # Like unsuccessful (e.g., user already liked the tweet)
  end

  # Method for quoting a tweet
  def quote_tweet(user, text_body)
    return nil if text_body.blank? # No se permite una cita de tweet vacía

    # Crear un nuevo tweet con el usuario actual como autor y el tweet original como cita
    quote = Tweet.new(user_id: user.id, quote_id: id, content: text_body)
    quote.save ? quote : nil
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

  validates :content, presence: true, length: { maximum: 255 }, if: -> { tweet_or_quote? }

  # Scope to retrieve the number of retweets
  scope :retweets_count, ->(tweet_id) { where(retweet_id: tweet_id).count }
  
  # Scope to retrieve the number of retweets
  scope :quotes_count, ->(tweet_id) { where(quote_id: tweet_id).count }

  def tweet_or_quote?
    retweet_id.nil?
  end

end
