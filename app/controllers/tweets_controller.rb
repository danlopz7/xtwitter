class TweetsController < ApplicationController

    before_action :set_tweet, only: [:update, :stats, :like, :unlike, :bookmark, :unbookmark, :retweet, :quote]

    # GET /users/:user_id/tweets
    def index
        @tweets = Tweet.all

        respond_to do |format|
            format.json { render json: @tweets }
        end
    end

    # POST /tweets === tweets_path 
    def create
        @tweet = Tweet.new(tweet_params)
    
        if @tweet.save
            tweet_hash = {
                "id": @tweet.id,
                "user": @tweet.user_id,
                "content": @tweet.content,
                "retweet_id": @tweet.retweet_id,
                "quote_id": @tweet.quote_id,
                "created_at": @tweet.created_at,
                "updated_at": @tweet.updated_at
            }
            render json: { tweet: tweet_hash }, status: :created
          else
            render json: @tweet.errors, status: :unprocessable_entity
        end
    end


    # PATCH/PUT /tweets/:id
    def update
      @tweet = Tweet.find(params[:id])
      if @tweet.update(tweet_params)
        tweet_hash = {
                "id": @tweet.id,
                "user": @tweet.user_id,
                "content": @tweet.content,
                "retweet_id": @tweet.retweet_id,
                "quote_id": @tweet.quote_id,
                "created_at": @tweet.created_at,
                "updated_at": @tweet.updated_at
            }
        render json: { tweet: tweet_hash }, status: :ok
      else
        render json: @tweet.errors, status: :unprocessable_entity
      end
    end


    # POST /tweets/:id/quote
    def quote
      original_tweet = Tweet.find(params[:id])
      current_user = tweet_params[:user_id]
  
      @quote_tweet = Tweet.new(content: tweet_params[:content], user_id: current_user, quote_id: original_tweet.id)
  
      if @quote_tweet.save
        quote_hash = {
                "id": @quote_tweet.id,
                "user": @quote_tweet.user_id,
                "content": @quote_tweet.content,
                "retweet_id": @quote_tweet.retweet_id,
                "quote_id": @quote_tweet.quote_id,
                "created_at": @quote_tweet.created_at,
                "updated_at": @quote_tweet.updated_at
            }
        render json: { tweet: quote_hash }, status: :created
      else
        render json: @tweet.errors, status: :unprocessable_entity
      end
    end

    # POST /tweets/:id/retweet
    def retweet
        original_tweet = Tweet.find(params[:id])
        current_user = tweet_params[:user_id]

        @retweet = Tweet.new(nil, user_id: current_user, retweet_id: original_tweet.id)
    
        if @retweet.save
            retweet_hash = {
                "id": @retweet.id,
                "user": @retweet.user_id,
                "content": @retweet.content,
                "retweet_id": @retweet.retweet_id,
                "quote_id": @retweet.quote_id,
                "created_at": @retweet.created_at,
                "updated_at": @retweet.updated_at
            }
          render json: retweet_hash, status: :created
        else
          render json: retweet.errors, status: :unprocessable_entity
        end
    end
  

    private

    def set_tweet
        @tweet = Tweet.find(params[:id])
    end

    def tweet_params
        params.require(:tweet).permit(:content, :user_id)
    end
end
