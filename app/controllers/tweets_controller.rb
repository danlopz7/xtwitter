class TweetsController < ApplicationController

    before_action :set_tweet, only: [:update, :stats, :like, :unlike, :bookmark, :unbookmark, :retweet, :quote]

    # GET /users/:user_id/tweets
    def index
        @tweets = Tweet.all

        respond_to do |format|
            format.json { render json: @tweets }
        end
    end
    
    
    def create
        @tweet = Tweet.new(tweet_params)
    
        respond_to do |format|
          if @tweet.save
            format.json { render json: @tweet, status: :created }
          else
            format.json { render json: @tweet.errors, status: :unprocessable_entity }
          end
        end
    end

    # PATCH/PUT /tweets/:id
    def update
      respond_to do |format|
        if @tweet.update(tweet_params)
            format.json { render json: @tweet, status: :ok }
        else
            format.json { render json: @tweet.errors, status: :unprocessable_entity }
        end
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
