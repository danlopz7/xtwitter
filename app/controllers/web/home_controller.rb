class HomeController < ApplicationController
    def index
      if user_signed_in?
        redirect_to web_tweets_path
      else
        @tweets = Tweet.order("RANDOM()").limit(10)
      end
    end
  end