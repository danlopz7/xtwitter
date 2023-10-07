class Web::TweetsController < Web::WebController
    include TweetStats

    # Como la clase padre ya tiene un `before_action` para `authenticate_user!`, 
    # sólo especificamos `:index` como excepción.
    before_action :authenticate_user! #, only: [:index]
    before_action :set_tweet, only: %i[show edit update retweet quote like unlike bookmark stats create_reply]
    

    # GET  /web/tweets  web_tweets_path
    # GET  /web/user/:username/tweets(/page/:page)  tweets_web_user_path

    def index
        page = params.fetch(:page, 0).to_i
        page_size = 10

        if params[:username]
            user = User.find_by(username: params[:username])
            #verificar esta linea
            @tweets = user.tweets.includes(:author).page(params[:page]).per(10).order(created_at: :desc)
        else
            page = params.fetch(:page, 0).to_i
            page_size = 10

            @tweets = current_user.tweets.order(created_at: :desc).offset(page * page_size).limit(page_size)
            #@tweets = current_user.feed.includes(:author).page(params[:page]).per(10).order(created_at: :desc)
        end 
        #render_response('web/tweets/index')
    end


    # POST  /web/tweets  
    def create
        @tweet = current_user.tweets.build(tweet_params)

      if @tweet.save
        redirect_to web_tweets_path, notice: "Tweet was successfully created."
      else
        render_response('web/tweets/new')
      end
    end

    # GET  /web/tweets/:id  web_tweet   
    def show
        render_response('web/tweets/show')
    end


    # PATCH/PUT  /web/tweets/:id
    def update
        if @tweet.update(tweet_params)
            render_response('web/tweets/show')
        else
            render_response('web/tweets/edit')
        end
    end

    
    #  GET  /web/tweets/new  new_web_tweet         
    def new
        @tweet = current_user.tweets.new
      render_response('web/tweets/new')
    end


    # POST /web/tweets/:id/replies  replies_web_tweet  
    def create_reply
        @reply = @tweet.replies.build(tweet_params.merge(user: current_user))

        if @reply.save
        redirect_to web_tweet_path(@tweet), notice: "Reply was successfully created."
        else
        render_response('web/tweets/show')
        end
    end


    # GET  /web/tweets/:id/stats  stats_web_tweet
    def stats
        @stats = get_stats(@tweet)
        render_response('web/tweets/stats')
    end


    # POST  /web/tweets/:id/bookmark  bookmark_web_tweet 
    def bookmark
        if current_user.bookmarks.find_by(tweet_id: @tweet.id)
            redirect_to web_tweet_path(@tweet), alert: "Tweet is already bookmarked."
        else
            current_user.bookmarks.create!(tweet_id: @tweet.id)
            redirect_to web_tweet_path(@tweet), notice: "Tweet was successfully bookmarked."
        end
    end


    # DELETE /web/tweets/:id/unlike  unlike_web_tweet
    def unlike
        current_user.likes.find_by(tweet: @tweet).destroy
        redirect_to web_tweet_path(@tweet), notice: "Tweet was successfully unliked."
    end


    # POST  /web/tweets/:id/like  like_web_tweet 
    def like
        if current_user.likes.find_by(tweet_id: @tweet.id)
            redirect_to web_tweet_path(@tweet), alert: "You've already liked this tweet."
        else
            current_user.likes.create!(tweet_id: @tweet.id)
            redirect_to web_tweet_path(@tweet), notice: "Tweet was successfully liked."
        end
    end


    # POST  /web/tweets/:id/quote  quote_web_tweet
    def quote
        @quoted_tweet = current_user.tweets.new(quote_id: @tweet.id)
        render_response('web/tweets/new')
    end


    #  POST  /web/tweets/:id/retweet  retweet_web_tweet
    def retweet
        current_user.tweets.create(retweet_id: @tweet.id, content: @tweet.content)
        redirect_to web_tweets_path, notice: "Tweet was successfully retweeted."
    end


    # GET  /web/user/:username/tweets_and_replies(/page/:page)  tweets_and_replies_web_user
    def tweets_and_replies
        @user = User.find_by(username: params[:username])
        @tweets = @user.tweets.includes(:replies).page(params[:page]).per(10).order(created_at: :desc)
        render_response('web/users/tweets_and_replies')
    end


    private
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:content)
    end

end