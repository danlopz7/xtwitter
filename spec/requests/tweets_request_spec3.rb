require 'rails_helper'

RSpec.describe "Api::Tweets", type: :request do

    let(:user) { create(:user) }

    # Métodos auxiliares
    def authenticate_user_get_token(user)
      post api_user_session_path, params: { user: { email: user.email, password: user.password } }
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
  
    describe "GET /tweets/:id" do
      let(:tweet) { create(:tweet, user: user) }
  
      it "retrieves a specific tweet" do
        get api_tweet_path(tweet.id), headers: @auth_headers
        expect(response).to have_http_status(:ok)
        # Agrega más expectativas según lo que quieras verificar
        #expect(response).to match_response_schema("tweet")
      end
    end

    context "when tweet doesn't exist" do
        it 'returns 404 not found' do
          get api_tweet_path(-1), headers: @auth_headers
          expect(response).to have_http_status(:not_found)
        end
    end


    describe "POST /tweets/:id/retweet" do
        let(:tweet) { create(:tweet) }
      
        it 'retweets a specific tweet' do
          post retweet_api_tweet_path(tweet), headers: @auth_headers
          expect(response).to have_http_status(:created)
          #expect(response).to match_response_schema("retweet")
        end
    end

    describe "POST /tweets/:id/quote" do
        let(:tweet) { create(:tweet) }
      
        it 'quotes a specific tweet' do
          post quote_api_tweet_path(tweet), params: { content: "This is a quote!" }, headers: @auth_headers
          expect(response).to have_http_status(:created)
          #expect(response).to match_response_schema("quote")
        end
    end

    describe "POST /tweets/:id/bookmark" do
        let(:tweet) { create(:tweet) }
      
        it 'bookmarks a specific tweet' do
          post bookmark_api_tweet_path(tweet), headers: @auth_headers
          expect(response).to have_http_status(:created)
          #expect(response).to match_response_schema("bookmark")
        end
      end
  end