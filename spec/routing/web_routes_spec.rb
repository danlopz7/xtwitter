require 'rails_helper'

RSpec.describe 'Web namespace Routes', type: :routing do
  describe 'Web::Users Controller' do
    it "routes to the current user's profile" do
      expect(get("/web/profile")).to route_to("web/users#profile")
    end

    it "routes to show user's profile" do
      expect(get("/web/user/johndoe")).to route_to("web/users#show", username: "johndoe")
    end

    describe "User-related routes" do
      it "routes to user's tweets" do
        expect(get("/web/user/johndoe/tweets")).to route_to("web/tweets#index", username: "johndoe")
      end

      it "routes to user's tweets with specific page" do
        expect(get("/web/user/johndoe/tweets/page/2")).to route_to("web/tweets#index", username: "johndoe", page: "2")
      end

      it "routes to user's tweets and replies" do
        expect(get("/web/user/johndoe/tweets_and_replies")).to route_to("web/tweets#tweets_and_replies", username: "johndoe")
      end

      it "routes to user's tweets and replies with specific page" do
        expect(get("/web/user/johndoe/tweets_and_replies/page/2")).to route_to("web/tweets#tweets_and_replies", username: "johndoe", page: "2")
      end
    end
  end

  describe 'Web::Tweets Controller' do
    it "routes to index tweets of current user and users they follow" do
      expect(get("/web/tweets")).to route_to("web/tweets#index")
    end

    it "routes to show a specific tweet" do
      expect(get("/web/tweets/1")).to route_to("web/tweets#show", id: "1")
    end

    it "routes to create a tweet" do
      expect(post("/web/tweets")).to route_to("web/tweets#create")
    end

    it "routes to update a tweet via PUT" do
      expect(put("/web/tweets/1")).to route_to("web/tweets#update", id: "1")
    end

    it "routes to update a tweet via PATCH" do
      expect(patch("/web/tweets/1")).to route_to("web/tweets#update", id: "1")
    end

    describe "Member actions on Tweets" do
      it "routes to retweet a tweet" do
        expect(post("/web/tweets/1/retweet")).to route_to("web/tweets#retweet", id: "1")
      end

      it "routes to quote a tweet" do
        expect(post("/web/tweets/1/quote")).to route_to("web/tweets#quote", id: "1")
      end

      it "routes to like a tweet" do
        expect(post("/web/tweets/1/like")).to route_to("web/tweets#like", id: "1")
      end

      it "routes to unlike a tweet" do
        expect(delete("/web/tweets/1/unlike")).to route_to("web/tweets#unlike", id: "1")
      end

      it "routes to bookmark a tweet" do
        expect(post("/web/tweets/1/bookmark")).to route_to("web/tweets#bookmark", id: "1")
      end

      it "routes to see tweet stats" do
        expect(get("/web/tweets/1/stats")).to route_to("web/tweets#stats", id: "1")
      end

      it "routes to create a reply for a tweet" do
        expect(post("/web/tweets/1/replies")).to route_to("web/tweets#create_reply", id: "1")
      end
    end
  end
end
