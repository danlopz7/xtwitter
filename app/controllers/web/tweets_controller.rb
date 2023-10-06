class Web::TweetsController < Web::WebController



    # GET  /web/tweets  tweets_web_user
    # GET  /web/user/:username/tweets(/page/:page)  tweets_web_user
    def index

    end

    # POST  /web/tweets  
    def create

    end


    # GET  /web/tweets/:id  web_tweet   
    def show

    end


    # PATCH/PUT  /web/tweets/:id
    def update
        if @tweet.update(user_params)
            render :show
        end
    end

    
    #  GET  /web/tweets/new  new_web_tweet         
    def new

    end


    # POST /web/tweets/:id/replies  replies_web_tweet  
    def create_reply

    end


    # GET  /web/tweets/:id/stats  stats_web_tweet
    def stats

    end


    # POST  /web/tweets/:id/bookmark  bookmark_web_tweet 
    def bookmark

    end


    # DELETE /web/tweets/:id/unlike  unlike_web_tweet
    def unlike

    end



    # POST  /web/tweets/:id/like  like_web_tweet 
    def like

    end


    # POST  /web/tweets/:id/quote  quote_web_tweet
    def quote

    end



    #  POST  /web/tweets/:id/retweet  retweet_web_tweet
    def retweet

    end


    # GET  /web/user/:username/tweets_and_replies(/page/:page)  tweets_and_replies_web_user
    def tweets_and_replies

    end
    

end