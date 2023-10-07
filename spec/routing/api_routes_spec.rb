require 'rails_helper'

RSpec.describe 'API namespace Routes', type: :routing do
    describe 'Api::Sessions Controller' do
      it "routes to sign in" do
        expect(post("/api/users/sign_in")).to route_to("api/sessions#create_user_token")
      end
  
      it "routes to sign out" do
        expect(delete("/api/users/sign_out")).to route_to("api/sessions#destroy_user_token")
      end
    end
  
    describe 'Api::Registration Controller' do
      it "routes to sign up" do
        expect(post("/api/users/sign_up")).to route_to("api/registration#create_user")
      end
    end
  
    describe 'Api::Users Controller' do
      it "routes to show user's profile" do
        expect(get("/api/user/johndoe")).to route_to("api/users#show", username: "johndoe")
      end
  
      describe "User-related routes" do
        it "routes to user's tweets" do
          expect(get("/api/user/johndoe/tweets")).to route_to("api/tweets#index", username: "johndoe")
        end
  
        it "routes to user's tweets with specific page" do
          expect(get("/api/user/johndoe/tweets/page/2")).to route_to("api/tweets#index", username: "johndoe", page: "2")
        end
  
        it "routes to user's tweets and replies" do
          expect(get("/api/user/johndoe/tweets_and_replies")).to route_to("api/tweets#tweets_and_replies", username: "johndoe")
        end
  
        it "routes to user's tweets and replies with specific page" do
          expect(get("/api/user/johndoe/tweets_and_replies/page/2")).to route_to("api/tweets#tweets_and_replies", username: "johndoe", page: "2")
        end
      end
    end
  
    describe 'Api::Tweets Controller' do
      it "routes to index tweets of current user and users they follow" do
        expect(get("/api/tweets")).to route_to("api/tweets#index")
      end
  
      it "routes to show a specific tweet" do
        expect(get("/api/tweets/1")).to route_to("api/tweets#show", id: "1")
      end
  
      it "routes to create a tweet" do
        expect(post("/api/tweets")).to route_to("api/tweets#create")
      end
  
      it "routes to update a tweet via PUT" do
        expect(put("/api/tweets/1")).to route_to("api/tweets#update", id: "1")
      end
  
      it "routes to update a tweet via PATCH" do
        expect(patch("/api/tweets/1")).to route_to("api/tweets#update", id: "1")
      end
  
      describe "Member actions on Tweets" do
        it "routes to retweet a tweet" do
          expect(post("/api/tweets/1/retweet")).to route_to("api/tweets#retweet", id: "1")
        end
  
        it "routes to quote a tweet" do
          expect(post("/api/tweets/1/quote")).to route_to("api/tweets#quote", id: "1")
        end
  
        it "routes to like a tweet" do
          expect(post("/api/tweets/1/like")).to route_to("api/tweets#like", id: "1")
        end
  
        it "routes to unlike a tweet" do
          expect(delete("/api/tweets/1/unlike")).to route_to("api/tweets#unlike", id: "1")
        end
  
        it "routes to bookmark a tweet" do
          expect(post("/api/tweets/1/bookmark")).to route_to("api/tweets#bookmark", id: "1")
        end
  
        it "routes to see tweet stats" do
          expect(get("/api/tweets/1/stats")).to route_to("api/tweets#stats", id: "1")
        end
  
        it "routes to create a reply for a tweet" do
          expect(post("/api/tweets/1/replies")).to route_to("api/tweets#create_reply", id: "1")
        end
      end
    end
  end