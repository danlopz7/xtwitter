
require 'rails_helper'

RSpec.describe "Api::Tweets", type: :request do

  let(:user) { create(:user) }

  # Métodos auxiliares
  def authenticate_user_get_token(user)
    post user_session, params: { id: user.id, password: user.password }
    json_response = JSON.parse(response.body)
    json_response["token"]
  end

  def authenticated_header(token)
    {
      'Authorization' => "Bearer #{token}",
      'Content-Type' => 'application/json'
    }
  end

  # Autenticación previa para las pruebas
  before do
    token = authenticate_user_get_token(user)
    @auth_headers = authenticated_header(token)
  end

#   describe "GET /users/:user_id/tweets" do
#     it "lists all tweets" do
#       get api_tweets_path, headers: @auth_headers
#       expect(response).to have_http_status(:ok)
#     end
#   end

  describe "GET /tweets/:id" do
    let!(:tweet) { create(:tweet, user: user) }

    it "displays a tweet" do
      get api_tweet_path(tweet), headers: @auth_headers
      expect(response).to have_http_status(:ok)
    end
  end

#   describe "POST /api/tweets" do
#     let(:valid_params) { { tweet: { content: "This is a test tweet" } } }

#     it "creates a new tweet" do
#       expect {
#         post api_tweets_path, params: valid_params.to_json, headers: @auth_headers
#       }.to change(Tweet, :count).by(1)

#       expect(response).to have_http_status(:created)
#     end
#   end

  describe "PATCH/PUT /tweets/:id" do
    let!(:tweet) { create(:tweet, user: user, content: "Original Content") }
    let(:update_params) { { tweet: { content: "Updated Content" } } }

    it "updates a tweet" do
      patch api_tweet_path(tweet), params: update_params.to_json, headers: @auth_headers
      expect(response).to have_http_status(:ok)
      expect(tweet.reload.content).to eq("Updated Content")
    end
  end
end
