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


    describe "root route" do
      it "routes to home#index" do
        expect(get: "/").to route_to("home#index")
      end
    end
  
    describe "web namespace" do
      it "routes to users#profile" do
        expect(get: "web/profile").to route_to("web/users#profile")
      end

      it "routes to a specific user's tweets" do
        expect(get: "web/user/johndoe/tweets").to route_to("web/tweets#index", username: "johndoe")
      end
  
      it "routes to a specific user's tweets with pagination" do
        expect(get: "web/user/johndoe/tweets?page=2").to route_to("web/tweets#index", username: "johndoe", page: "2")
      end
  
      it "routes to a specific user's tweets and replies" do
        expect(get: "web/user/johndoe/tweets_and_replies").to route_to("web/tweets#tweets_and_replies", username: "johndoe")
      end
  
      it "routes to a specific user's tweets and replies with pagination" do
        expect(get: "web/user/johndoe/tweets_and_replies?page=2").to route_to("web/tweets#tweets_and_replies", username: "johndoe", page: "2")
      end
  
      describe "tweets resource" do
        it "routes to tweets#index" do
          expect(get: "web/tweets").to route_to("web/tweets#index")
        end
  
        it "routes to tweets#show" do
          expect(get: "web/tweets/1").to route_to("web/tweets#show", id: "1")
        end
  
        it "routes to tweets#create" do
          expect(post: "web/tweets").to route_to("web/tweets#create")
        end
  
        it "routes to tweets#update" do
          expect(put: "web/tweets/1").to route_to("web/tweets#update", id: "1")
        end
  
        it "routes to tweets#new" do
          expect(get: "web/tweets/new").to route_to("web/tweets#new")
        end
  
        it "routes to tweets#retweet" do
          expect(post: "web/tweets/1/retweet").to route_to("web/tweets#retweet", id: "1")
        end
  
        it "routes to tweets#quote" do
          expect(post: "web/tweets/1/quote").to route_to("web/tweets#quote", id: "1")
        end
  
        it "routes to tweets#like" do
          expect(post: "web/tweets/1/like").to route_to("web/tweets#like", id: "1")
        end
  
        it "routes to tweets#unlike" do
          expect(delete: "web/tweets/1/unlike").to route_to("web/tweets#unlike", id: "1")
        end
  
        it "routes to tweets#bookmark" do
          expect(post: "web/tweets/1/bookmark").to route_to("web/tweets#bookmark", id: "1")
        end
  
        it "routes to tweets#stats" do
          expect(get: "web/tweets/1/stats").to route_to("web/tweets#stats", id: "1")
        end
  
        it "routes to tweets#create_reply" do
          expect(post: "web/tweets/1/replies").to route_to("web/tweets#create_reply", id: "1")
        end
      end
    end
end