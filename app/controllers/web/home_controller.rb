class Web::HomeController < ApplicationController
  include TweetStats

  # GET web/root web_root_path
  def index
    if user_signed_in?
      redirect_to web_tweets_path
    else
      # Traer los primeros 10 tweets 
      @random_tweets = Tweet.order("RANDOM()").limit(10)
      @tweets_with_stats = @random_tweets.map do |tweet|
        {
          tweet: tweet,
          stats: get_stats(tweet)
        }
      end
    end
  end
end