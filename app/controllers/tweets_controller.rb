class TweetsController < ApplicationController
    include TweetStats

    before_action :set_tweet, only: [:update, :stats, :like, :unlike, :bookmark, :unbookmark, :retweet, :quote]
    
    # GET /users/:user_id/tweets
    def index
        @tweets = Tweet.all
        render_to_json(@tweets)
    end

    # POST /tweets === tweets_path 
    def create
      @tweet = Tweet.new(tweet_params)
      if @tweet.save
        render json: @tweet, status: :created
      else
        render json: @tweet.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /tweets/:id
    def update
      if @tweet.update(tweet_params)
        render json: @tweet, status: :ok
      else
        render json: @tweet.errors, status: :unprocessable_entity
      end
    end

    def stats
      response = get_stats(@tweet)
      render_to_json(response)
    end

    # POST /tweets/:id/quote
    def quote
      original_tweet = @tweet
      current_user = tweet_params[:user_id]
  
      @quote_tweet = Tweet.new(content: tweet_params[:content], user_id: current_user, quote_id: original_tweet.id)
  
      if @quote_tweet.save
        render json: @quote_tweet, status: :created
      else
        render json: @tweet.errors, status: :unprocessable_entity
      end
    end

    # POST /tweets/:id/retweet
    def retweet
        original_tweet = @tweet
        current_user = tweet_params[:user_id]

        @retweet = Tweet.new(user_id: current_user, retweet_id: original_tweet.id)
    
        if @retweet.save
          render json: @retweet, status: :created
        else
          render json: @retweet.errors, status: :unprocessable_entity
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




# POST /tweets === tweets_path 
# def create
        

#   @tweet = Tweet.new(tweet_params)

#   if @tweet.save
#       tweet_hash = {
#           "id": @tweet.id,
#           "user": @tweet.user_id,
#           "content": @tweet.content,
#           "retweet_id": @tweet.retweet_id,
#           "quote_id": @tweet.quote_id,
#           "created_at": @tweet.created_at,
#           "updated_at": @tweet.updated_at
#       }
#       render json: { tweet: tweet_hash }, status: :created
#     else
#       render json: @tweet.errors, status: :unprocessable_entity
#   end
# end

 # PATCH/PUT /tweets/:id
#  def update
#   if @tweet.update(tweet_params)
#     tweet_hash = {
#             "id": @tweet.id,
#             "user": @tweet.user_id,
#             "content": @tweet.content,
#             "retweet_id": @tweet.retweet_id,
#             "quote_id": @tweet.quote_id,
#             "created_at": @tweet.created_at,
#             "updated_at": @tweet.updated_at
#         }
#     render json: { tweet: tweet_hash }, status: :ok
#   else
#     render json: @tweet.errors, status: :unprocessable_entity
#   end
# end


        # respond_to do |format|
        #     format.json { render json: @tweets }
        # end