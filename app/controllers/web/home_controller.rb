class Web::HomeController < ApplicationController

  # GET web/root web_root_path
  def index
    if user_signed_in?
      redirect_to web_tweets_path
    else
      # Traer los primeros 10 tweets 
      @random_tweets = Tweet.order("RANDOM()").limit(10).sort_by(&:created_at).reverse
    end
  end
end