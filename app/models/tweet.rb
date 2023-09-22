class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :retweet, class_name: 'Tweet', foreign_key: 'retweet_id', optional: true
  belongs_to :quote, class_name: 'Tweet', foreign_key: 'quote_id', optional: true

  has_many :retweets, class_name: 'Tweet', foreign_key: 'retweet_id'
  has_many :quote_tweets, class_name: 'Tweet', foreign_key: 'quote_id'
  has_many :replies, class_name: 'Reply', foreign_key: 'tweet_id'
  has_many :bookmarks
  has_many :likes

  has_and_belongs_to_many :hashtags, join_table: 'hashtags_tweets'
  #Esta relación permite que un tweet pueda tener múltiples hashtags, y a su vez, un hashtag puede estar asociado con varios tweets.
  #Cuando se utiliza esta relación, Rails espera que exista una tabla intermedia en la base de datos 
  #que vincule los registros de los dos modelos.
  #En el contexto de esta relación, se espera que haya una tabla intermedia llamada "tweets_hashtags" 
  #(por convención, Rails utiliza el nombre de ambos modelos en orden alfabético y en plural para nombrar 
  #la tabla intermedia). Esta tabla debe tener dos columnas: "tweet_id" y "hashtag_id". La columna "tweet_id" 
  #almacena el ID del tweet y la columna "hashtag_id" almacena el ID del hashtag asociado. Cuando se llama 
  # a has_and_belongs_to_many :hashtags, Rails automáticamente configura la relación de muchos a muchos y 
  #permite que puedas agregar y recuperar hashtags asociados a un tweet de manera sencilla

  validates :content, presence: true, length: { maximum: 255 }, if: -> { tweet_or_quote? }

  def tweet_or_quote?
    retweet_id.nil?
  end

  # Scope to retrieve the number of retweets
  scope :retweets_count, ->(tweet_id) { where(retweet_id: tweet_id).count }

end
