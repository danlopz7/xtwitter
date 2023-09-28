require 'rails_helper'

RSpec.describe "Routing to Tweets", type: :routing do

    # CRUD Routes for Tweets
    describe "Tweets CRUD operations defined" do
        it "routes to /create to the tweets controller" do
            expect(post("/tweets")).to route_to("tweets#create")
        end

        it "routes to /update via PUT to the tweets controller" do
            expect(put("/tweets/1")).to route_to("tweets#update", id: "1")
        end

        it "routes to /update via PATCH to the tweets controller" do
            expect(patch("/tweets/1")).to route_to("tweets#update", id: "1")
        end
    end

    # Member routes for Tweets
    describe "Member actions on Tweets" do
        it "routes to /tweets/:id/stats to the tweets controller" do
            expect(get("/tweets/1/stats")).to route_to("tweets#stats", id: "1")
        end

        it "routes to /tweets/:id/like to the tweets controller" do
            expect(post("/tweets/1/like")).to route_to("tweets#like", id: "1")
        end

        it "routes to /tweets/:id/unlike to the tweets controller" do
            expect(delete("/tweets/1/unlike")).to route_to("tweets#unlike", id: "1")
        end

        it "routes to /tweets/:id/bookmark to the tweets controller" do
            expect(post("/tweets/1/bookmark")).to route_to("tweets#bookmark", id: "1")
        end

        it "routes to tweets/:id/unbookmark to the tweets controller" do
            expect(delete("/tweets/1/unbookmark")).to route_to("tweets#unbookmark", id: "1")
        end

        it "routes to /tweets/:id/retweet to the tweets controller" do
            expect(post("/tweets/1/retweet")).to route_to("tweets#retweet", id: "1")
        end

        it "routes to /tweets/:id/quote to the tweets controller" do
            expect(post("/tweets/1/quote")).to route_to("tweets#quote", id: "1")
        end
    end

    # Nested resources under Tweets for Replies
    describe "Replies under Tweets" do
        it "routes to /tweets/:tweet_id/replies for replies under tweets to the replies controller" do
            expect(post("/tweets/1/replies")).to route_to("replies#create", tweet_id: "1")
        end
    end

    # Routes for User Tweets and Paginated Tweets
    describe "User Tweets" do
        it "routes to /users/:user_id/tweets(/page/:page) tweets with optional pagination to the tweet controller" do
            expect(get("/users/1/tweets/page/2")).to route_to("tweets#index", user_id: "1", page: "2")
        end

        it "routes to /users/:user_id/tweets_and_replies(/page/:page) tweets and replies with optional pagination to the tweet controller" do
            expect(get("/users/1/tweets_and_replies/page/2")).to route_to("tweets#tweets_and_replies", user_id: "1", page: "2")
        end
    end
end