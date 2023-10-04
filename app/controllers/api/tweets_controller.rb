class Api::TweetsController < Api::ApiController
    include TweetStats

    before_action :set_tweet, only: [:update, :stats, :retweet, :quote, :bookmark, :unbookmark, :like, :unlike, :tweets_and_replies]
    before_action :authenticate_user!, except: [:index, :show]
    
    # GET /users/:user_id/tweets
    def index
        @tweets = Tweet.all
        #render json: { tweet: @tweets }, status: :ok
    end

    def show
      @tweet = Tweet.find(params[:id])
    end


    def tweets_and_replies
        @tweets_and_replies = Tweet.user_tweets_and_replies(@tweet.user_id)
        #render json: { tweet: @tweets_and_replies }, status: :ok
    end


    # POST /tweets === tweets_path 
    def create
      @tweet = Tweet.new(tweet_params)
      #@tweet = current_user.tweets.new(tweet_params)

      if @tweet.save
        render status: :created
      else
        render status: :unprocessable_entity
      end
    end


    # PATCH/PUT /tweets/:id
    def update
      if @tweet.update(tweet_params)
        render status: :ok
      else
        render status: :unprocessable_entity
      end
    end


    def stats
      @stats_response = get_stats(@tweet)
      #render json: { stats: response }, status: :ok
    end


    # POST /tweets/:id/quote
    def quote
      original_tweet = @tweet
      current_user = tweet_params[:user_id]
  
      @quote_tweet = Tweet.new(user_id: current_user, content: tweet_params[:content], quote_id: original_tweet.id)

      if @quote_tweet.save
        render status: :created
      else
        render status: :unprocessable_entity
      end
    end


    # POST /tweets/:id/retweet
    def retweet
      user = User.find(params[:user_id]) # Obtener el usuario desde los parámetros
      @retweet = @tweet.retweet(user)

      if @retweet
        render status: :created
      else
        render status: :unprocessable_entity
      end
    end


    # POST /tweets/:id/like
    def like
        user = User.find(params[:user_id])
        @liked = @tweet.like(user)

        unless @liked
            render_errors(@liked)
        end
    end


    # DELETE /tweets/:id/unlike
    def unlike
        @unlike = Like.find_by(user_id: @tweet.user_id, tweet_id: @tweet.id)
        unless @unlike&.destroy
            render json: { errors: ["Like not found or could not be deleted"] }, status: :unprocessable_entity
        end
    end


    # POST /tweets/:id/bookmark
    def bookmark
        user = User.find(params[:user_id])
        @bookmark = @tweet.bookmark(user)

        unless @bookmark.valid?
            render_errors(@liked)
        end
    end
    
    
    # DELETE /tweets/:id/unbookmark
    def unbookmark
        @unbookmark = Bookmark.find_by(user_id: params[:user_id], tweet_id: @tweet.id)
  
        unless @unbookmark&.destroy
            render json: { errors: ['Bookmark not found.'] }, status: :unprocessable_entity
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