require 'rails_helper'

describe 'Routing to Api::Tweets Controller' do 
        
    # CRUD Routes for Tweets
    describe "Tweets CRUD operations defined" do
        it "routes to /api/tweets to the tweets controller" do
            expect(post("/api/tweets")).to route_to("api/tweets#create")
        end

        it "routes to /api/tweets/:id via PUT to the tweets controller" do
            expect(put("/api/tweets/1")).to route_to("api/tweets#update", id: "1")
        end

        it "routes to /api/tweets/:id via PATCH to the tweets controller" do
            expect(patch("/api/tweets/1")).to route_to("api/tweets#update", id: "1")
        end
    end

    # Member routes for Tweets
    describe "Member actions on Tweets" do
        it "routes to /api/tweets/:id/stats to the tweets controller" do
            expect(get("/api/tweets/1/stats")).to route_to("api/tweets#stats", id: "1")
        end

        it "routes to /api/tweets/:id/like to the tweets controller" do
            expect(post("/api/tweets/1/like")).to route_to("api/tweets#like", id: "1")
        end

        it "routes to /api/tweets/:id/unlike to the tweets controller" do
            expect(delete("/api/tweets/1/unlike")).to route_to("api/tweets#unlike", id: "1")
        end

        it "routes to /api/tweets/:id/bookmark to the tweets controller" do
            expect(post("/api/tweets/1/bookmark")).to route_to("api/tweets#bookmark", id: "1")
        end

        it "routes to /api/tweets/:id/retweet to the tweets controller" do
            expect(post("/api/tweets/1/retweet")).to route_to("api/tweets#retweet", id: "1")
        end

        it "routes to /api/tweets/:id/quote to the tweets controller" do
            expect(post("/api/tweets/1/quote")).to route_to("api/tweets#quote", id: "1")
        end
    end

    # Routes for User Tweets and Paginated Tweets
    describe "User Tweets" do
        it "routes to /api/users/:user_id/tweets(/page/:page) tweets with optional pagination to the tweet controller" do
            expect(get("/api/users/1/tweets/page/2")).to route_to("api/tweets#index", user_id: "1", page: "2")
        end

        it "routes to /api/users/:user_id/tweets_and_replies(/page/:page) tweets and replies with optional pagination to the tweet controller" do
            expect(get("/api/users/1/tweets_and_replies/page/2")).to route_to("api/tweets#tweets_and_replies", user_id: "1", page: "2")
        end
    end


    describe 'Routing to Api::Tweets Controller' do 
        # Nested resources under Tweets for Replies
        describe "Replies under Tweets" do
            it "routes to /api/tweets/:tweet_id/replies for replies under tweets to the tweets controller" do
            expect(post("/api/tweets/1/replies")).to route_to("api/tweets#create", tweet_id: "1")
            end
        end
    end
end