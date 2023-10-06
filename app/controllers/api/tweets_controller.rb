class Api::TweetsController < Api::ApiController
  include TweetStats

  before_action :set_tweet, except: [ :index, :tweets_and_replies, :create ]
  before_action :authenticate_user!#, except: [:index, :show]

  # GET  /api/users/:user_id/tweets(/page/:page)
  # muestra la lista de tweets de un determinado usuario
  def index
    user = User.find(params[:user_id])
    @tweets = user.tweets
      #render json: { tweet: @tweets }, status: :ok
  end


  # GET  /api/users/:user_id/tweets_and_replies(/page/:page)
  # muestra la lista de tweets y replies de un determinado usuario
  def tweets_and_replies
    user = User.find(params[:user_id])
    @tweets_and_replies = Tweet.tweets_and_replies(user.id)
    #render status: :ok
  end


  # GET  /api/users/:user_id/tweets/:id  api_user_tweet
  def show
    @tweet
  end


  # POST  /api/users/:user_id/tweets  api_user_tweets
  def create
    #@tweet = Tweet.new(tweet_params)
    @tweet = current_user.tweets.new(content: params[:tweet][:content])

    unless @tweet.save
      render json: { errors: @tweet.errors.full_messages }, status: :unprocessable_entity
    end
  end


  # PUT/PATCH  /api/users/:user_id/tweets/:id
  def update
    unless @tweet.update(tweet_params)
      render json: { errors: @tweet.errors.full_messages }, status: :unprocessable_entity
    end
  end


  # POST  /api/users/:user_id/tweets/:id/retweet  retweet_api_user_tweet
  def retweet
    @retweet = @tweet.retweet(current_user)

    if @retweet
      render json: @retweet, status: :created
    else
      render status: :unprocessable_entity
    end
  end


  # POST  /api/users/:user_id/tweets/:id/quote   quote_api_user_tweet
  def quote
    @quote_tweet = @tweet.quote_tweet(current_user, content: params[:content])

    unless @quote_tweet
      render json: { errors: @quote_tweet.errors.full_messages }, status: :unprocessable_entity
    end
  end

    
  # POST  /api/users/:user_id/tweets/:id/like  like_api_user_tweet
  def like
    @like = @tweet.like(current_user)

    unless @like
      render json: { errors: @like.errors.full_messages }, status: :unprocessable_entity
    end
  end


  # DELETE /api/users/:user_id/tweets/:id/unlike  unlike_api_user_tweet
  def unlike
    @unlike = Like.find_by(user_id: current_user, tweet_id: @tweet.id)
    unless @unlike&.destroy
      render json: { errors: ["Like not found or could not be deleted"] }, status: :unprocessable_entity
    end
  end


  # POST /api/users/:user_id/tweets/:id/bookmark  bookmark_api_user_tweet
  def bookmark
    #user = User.find(params[:user_id])
    @bookmark = @tweet.bookmark(current_user)

    unless @bookmark
      render json: { errors: @bookmark.errors.full_messages }, status: :unprocessable_entity
    end
  end


  # GET  /api/users/:user_id/tweets/:id/stats  stats_api_user_tweet
  def stats
    @stats_response = get_stats(@tweet)
    #render json: { stats: response }, status: :ok
  end


  # POST /api/users/:user_id/tweets/:id/replies  replies_api_user_tweet
  def create_reply
    @reply = Reply.new(content: [:reply][:content])
    @reply.user = current_user
    @reply.tweet = @tweet
  
    unless @reply.save
      render json: { errors: @reply.errors.full_messages }, status: :unprocessable_entity
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
