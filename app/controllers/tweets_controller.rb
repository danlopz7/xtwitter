class TweetsController < ApplicationController
    include TweetStats

    before_action :set_tweet, only: [:update, :stats, :retweet, :quote, :bookmark, :unbookmark, :like, :unlike, :tweets_and_replies]
    
    # GET /users/:user_id/tweets
    def index
        @tweets = Tweet.all
        render json: { tweet: @tweets }, status: :ok
    end

    def tweets_and_replies
        @tweets_and_replies = Tweet.user_tweets_and_replies(@tweet.user_id)
        render json: { tweet: @tweets_and_replies }, status: :ok
    end

    # POST /tweets === tweets_path 
    def create
      @tweet = Tweet.new(tweet_params)

      respond_to do |format| 
        if @tweet.save
            format.json { render json: { tweet: @tweet }, status: :created }
          else
            format.json { render json: { errors: @tweet.errors.full_messages }, status: :unprocessable_entity }
          end
      end
    end

    # PATCH/PUT /tweets/:id
    def update
      if @tweet.update(tweet_params)
        render json: { tweet: @tweet }, status: :ok
      else
        render json: { errors: @tweet.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def stats
      response = get_stats(@tweet)
      render json: { stats: response }, status: :ok
    end

    # POST /tweets/:id/quote
    def quote
      original_tweet = @tweet
      current_user = tweet_params[:user_id]
  
      quote_tweet = Tweet.new(user_id: current_user, content: tweet_params[:content], quote_id: original_tweet.id)
  
      if quote_tweet.save
        render json: { tweet: quote_tweet }, status: :created
      else
        render json: { errors: quote_tweet.errors.full_messages }, status: :unprocessable_entity
      end
    end

    
    # POST /tweets/:id/retweet
    def retweet
    user = User.find(params[:user_id]) # Obtener el usuario desde los parámetros
    retweet = @tweet.retweet(user)

        if retweet
        render json: { tweet: retweet }, status: :created
        else
        render json: { errors: ["You've already retweeted this tweet."] }, status: :unprocessable_entity
        end
    end

    # POST /tweets/:id/like
    def like
        user = User.find(params[:user_id])
        liked = @tweet.like(user)
        if liked
            render json: { like: liked }, status: :ok
        else
            render json: { errors: ["You've already liked this tweet."] }, status: :unprocessable_entity
        end
    end

    # DELETE /tweets/:id/unlike
    def unlike
        unlike = Like.find_by(user_id: @tweet.user_id, tweet_id: @tweet.id)
        if unlike&.destroy
            head :ok
        else
            render json: { errors: ["Like not found or could not be deleted"] }, status: :unprocessable_entity
        end
    end

    # POST /tweets/:id/bookmark
    def bookmark
        user = User.find(params[:user_id])
        bookmark = @tweet.bookmark(user)

        if bookmark
            render json: { bookmark: bookmark }, status: :ok
        else
            render json: { errors: ["You've already bookmarked this tweet."] }, status: :unprocessable_entity
        end
    end
    
    
    # DELETE /tweets/:id/unbookmark
    def unbookmark
        unbookmark = Bookmark.find_by(user_id: params[:user_id], tweet_id: @tweet.id)
        if unbookmark&.destroy
            head :ok
        else
            render json: { errors: ['Bookmark not found'] }, status: :unprocessable_entity
        end
    end
    

    # DELETE /tweets/:id/unbookmark
    def unbookmark
        bookmark = Bookmark.find_by(user_id: params[:user_id], tweet_id: @tweet.id)
  
        if bookmark && bookmark.destroy
            render json: { message: "Bookmark removed" }, status: :ok
        else
            render json: { errors: ["Bookmark not found or could not be deleted"] }, status: :unprocessable_entity
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