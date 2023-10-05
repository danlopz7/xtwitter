class Api::TweetsController < Api::ApiController
    include TweetStats

    before_action :set_tweet, only: [:show, :update, :stats, :retweet, :quote, :bookmark, :unbookmark, :like, :unlike, :tweets_and_replies]
    before_action :authenticate_user!#, except: [:index, :show]
    
    # GET /api/users/:user_id/tweets(/page/:page)
    def index
        @tweets = User.find(params[:user_id])
        render status: :ok
        #render json: { tweet: @tweets }, status: :ok
    end

    # GET /api/tweets/:id 
    def show
    end

    # GET /api/users/:user_id/tweets_and_replies(/page/:page)
    def tweets_and_replies
      user = User.find(params[:user_id])
      @tweets_and_replies = @tweet.user_tweets_and_replies(user)
      render status: :ok
    end

    # POST /api/tweets
    def create
      #@tweet = Tweet.new(tweet_params)
      @tweet = current_user.tweets.new(tweet_params)

      if @tweet.save
        render status: :created
      else
        render status: :unprocessable_entity
      end
    end

    # PUT/PATCH /api/tweets/:id
    def update
      @tweet = current_user.tweets.find(params[:id])
      if @tweet.update(tweet_params)
        render status: :ok
      else
        render status: :unprocessable_entity
      end
      # if @tweet.update(tweet_params)
      #   render status: :ok
      # else
      #   render status: :unprocessable_entity
      # end
    end

    # 
    def stats
      @stats_response = get_stats(@tweet)
      #render json: { stats: response }, status: :ok
    end

    # POST /api/tweets/:id/quote
    def quote
      # original_tweet = @tweet
      # current_user = tweet_params[:user_id]
      @quote_tweet = @tweet.quote_tweet(current_user, content: params[:content])

      if @quote_tweet
        render json: @quoted_tweet, status: :created
      else
        render status: :unprocessable_entity
      end
    end

    # POST /api/tweets/:id/retweet
    def retweet
      #user = User.find(params[:user_id]) # Obtener el usuario desde los parámetros
      @retweet = @tweet.retweet(current_user)

      if @retweet
        render json: @retweet, status: :created
      else
        render status: :unprocessable_entity
      end
    end

    # POST /api/tweets/:id/like
    def like
        #user = User.find(params[:user_id])
        @liked = @tweet.like(current_user)

        if @like
          render json: @like, status: :created
        else
          render status: :unprocessable_entity
        end
    end

    # DELETE /tweets/:id/unlike
    def unlike
        @unlike = Like.find_by(user_id: current_user, tweet_id: @tweet.id)
        unless @unlike&.destroy
            render json: { errors: ["Like not found or could not be deleted"] }, status: :unprocessable_entity
        end
    end

    # POST /tweets/:id/bookmark
    def bookmark
      #user = User.find(params[:user_id])
      @bookmark = @tweet.bookmark(current_user)

      if @bookmark
        render json: @bookmark, status: :created
      else
        render status: :unprocessable_entity
      end
    end

    def create_reply
    end
  
    private

    def set_tweet
        @tweet = Tweet.find(params[:id])
    end

    def tweet_params
        params.require(:tweet).permit(:content, :user_id)
    end
end