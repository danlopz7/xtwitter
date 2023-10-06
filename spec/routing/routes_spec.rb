require 'rails_helper'

describe 'Routing to API namespace' do 

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
  
    describe 'Api::Tweets Controller' do 
  
      describe "User Tweets" do
        it "routes to user's tweets with optional pagination" do
          expect(get("/api/users/1/tweets")).to route_to("api/tweets#index", user_id: "1")
        end
        
        it "routes to user's tweets with specific page" do
          expect(get("/api/users/1/tweets/page/2")).to route_to("api/tweets#index", user_id: "1", page: "2")
        end
  
        it "routes to user's tweets and replies with optional pagination" do
          expect(get("/api/users/1/tweets_and_replies/page/2")).to route_to("api/tweets#tweets_and_replies", user_id: "1", page: "2")
        end
      end
  
      describe "Tweets CRUD operations" do
        it "routes to create a tweet" do
          expect(post("/api/users/1/tweets")).to route_to("api/tweets#create", user_id: "1")
        end
  
        it "routes to show a tweet" do
          expect(get("/api/users/1/tweets/2")).to route_to("api/tweets#show", user_id: "1", id: "2")
        end
  
        it "routes to update a tweet via PUT" do
          expect(put("/api/users/1/tweets/2")).to route_to("api/tweets#update", user_id: "1", id: "2")
        end
  
        it "routes to update a tweet via PATCH" do
          expect(patch("/api/users/1/tweets/2")).to route_to("api/tweets#update", user_id: "1", id: "2")
        end
      end
  
      describe "Member actions on Tweets" do
        
        it "routes to retweet a tweet" do
          expect(post("/api/users/1/tweets/2/retweet")).to route_to("api/tweets#retweet", user_id: "1", id: "2")
        end
  
        it "routes to quote a tweet" do
          expect(post("/api/users/1/tweets/2/quote")).to route_to("api/tweets#quote", user_id: "1", id: "2")
        end
  
        it "routes to like a tweet" do
          expect(post("/api/users/1/tweets/2/like")).to route_to("api/tweets#like", user_id: "1", id: "2")
        end
  
        it "routes to unlike a tweet" do
          expect(delete("/api/users/1/tweets/2/unlike")).to route_to("api/tweets#unlike", user_id: "1", id: "2")
        end
  
        it "routes to bookmark a tweet" do
          expect(post("/api/users/1/tweets/2/bookmark")).to route_to("api/tweets#bookmark", user_id: "1", id: "2")
        end
  
        it "routes to tweet stats" do
          expect(get("/api/users/1/tweets/2/stats")).to route_to("api/tweets#stats", user_id: "1", id: "2")
        end
  
      end
  
      describe "Replies under Tweets" do
        it "routes to create a reply for a tweet" do
          expect(post("/api/users/1/tweets/2/replies")).to route_to("api/tweets#create_reply", user_id: "1", id: "2")
        end
      end
  
    end
end