require 'rails_helper'

RSpec.describe "Users", type: :request do

  let(:user) { create(:user) }
  let(:tweet) { create(:tweet, user: user) }
  let(:reply) { create(:reply, user: user, tweet: tweet) }

  describe "GET /users/:id/tweets" do
    context "with valid user id" do
      it "returns a list of user's tweets" do
        get user_tweets_path(user.id)

        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema("user_tweets")
      end

      it "returns paginated tweets for the user" do
        get user_tweets_path(user.id, page: 2)
  
        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema("user_tweets")
      end
    end

    context "with invalid user id" do
      it "returns not found" do
        get user_tweets_path(user.id + 1)

        expect(response).to have_http_status(404)
      end
    end
  end

  describe "GET /users/:id/tweets_and_replies" do
    context "with valid user id" do
      it "returns tweets and replies for the user" do
        get user_tweets_and_replies_path(user.id)

        expect(response.status).to have_http_status(:ok)
        expect(response).to match_response_schema("tweets_and_replies")
      end

      it "returns paginated tweets and replies for the user" do
        get tweets_and_replies_user_path(user.id, page: 2)
  
        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema("tweets_and_replies")
      end
    end

    context "with invalid user id" do
      it "returns not found" do
        get user_tweets_and_replies_path(user.id + 1)
        
        expect(response).to have_http_status(404)
      end
    end
  end
end