require 'rails_helper'

RSpec.describe "Api::Tweets", type: :request do

  let(:user) { create(:user) }

  # Métodos auxiliares
  def authenticate_user_get_token(user)
    JsonWebToken.encode(sub: user.id)
  end
  
  def authenticated_header(token)
    { 'Authorization' => "Bearer #{token}" }
  end
  
  # Autenticación previa para las pruebas
  before do
    token = authenticate_user_get_token(user)
    @auth_headers = authenticated_header(token)
  end
  
  
  describe "GET /api/tweets/:id" do
    let(:tweet) { create(:tweet, user: user) }
  
    context "retrieves a specific tweet" do
      it "returns 200 status for retrieving a tweet" do
        get api_tweet_path(tweet.id), headers: @auth_headers

        expect(response).to have_http_status(:ok)
      end
      it "returns a json matching json schema" do
        get api_tweet_path(tweet.id), headers: @auth_headers

        expect(response).to match_response_schema("tweet")
      end
    end
  
    context "when tweet doesn't exist" do
      it 'returns 404 not found' do
        get api_tweet_path(-1), headers: @auth_headers
        
        expect(response).to have_http_status(:not_found)
      end
    end
  end


  describe "POST api/tweets" do
    let(:valid_params) { { tweet: { content: "A new tweet", user_id: user.id } } }
    let(:invalid_params) { { tweet: { content: "" } } }  # contenido vacío como ejemplo de parámetro inválido
    context "with valid parameters" do
      it "creates a new tweet", only: true do
        puts @auth_headers.class
        expect {
          post api_tweets_path, params: valid_params, headers: @auth_headers
        }.to change(Tweet, :count).by(1)

        expect(response).to have_http_status(:created)
      end

      it "returns the newly created tweet in the response" do
        post api_tweets_path, params: valid_params, headers: @auth_headers

        expect(response).to match_response_schema("tweet")
      end
    end

    context "with invalid parameters" do
      it "does not create a new tweet" do
        expect {
          post api_tweets_path, params: invalid_params, headers: @auth_headers
        }.not_to change(Tweet, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns error messages in the response" do
        post api_tweets_path, params: invalid_params, headers: @auth_headers

        parsed_response = JSON.parse(response.body)
        expect(parsed_response["errors"]).not_to be_empty
      end
    end
  end


  describe "PUT/PATCH api/tweets/:id" do
    let(:tweet) { create(:tweet, user: user) }
  
    context "with valid parameters" do
      let(:valid_params) { { tweet: { content: "Updated tweet content" } } } # Actualizamos el contenido como un ejemplo válido
  
      it "updates the tweet" do
        put api_tweet_path(tweet.id), params: valid_params, headers: @auth_headers
        tweet.reload
  
        expect(tweet.content).to eq("Updated tweet content")
      end
  
      it "returns 200 status for successfully updating the tweet" do
        put api_tweet_path(tweet.id), params: valid_params, headers: @auth_headers
  
        expect(response).to have_http_status(:ok)
      end
  
      it "returns the updated tweet in the response" do
        put api_tweet_path(tweet.id), params: valid_params, headers: @auth_headers
  
        expect(response).to match_response_schema("tweet")
      end
    end
  
    context "with invalid parameters" do
      let(:invalid_params) { { tweet: { content: "" } } }  # contenido vacío como un ejemplo inválido
  
      it "does not update the tweet" do
        expect {
          put api_tweet_path(tweet.id), params: invalid_params, headers: @auth_headers
        }.not_to change { tweet.reload.content }
      end
  
      it "returns 422 status for unsuccessful update" do
        put api_tweet_path(tweet.id), params: invalid_params, headers: @auth_headers
  
        expect(response).to have_http_status(:unprocessable_entity)
      end
  
      it "returns error messages in the response" do
        put api_tweet_path(tweet.id), params: invalid_params, headers: @auth_headers
  
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["errors"]).not_to be_empty
      end
    end
  end


  describe "POST api/tweets/:id/quote" do
    let!(:tweet) { create(:tweet, user: user) }
    let!(:valid_quote_params) do 
      { 
        tweet: { 
          content: "This is a quoted tweet.", 
          original_tweet_id: tweet.id, 
          user_id: user.id 
        } 
      }
    end
    let!(:invalid_quote_params) do 
      { 
        tweet: { 
          content: "", 
          original_tweet_id: tweet.id, 
          user_id: user.id 
        } 
      }
    end

    context "with valid params" do
      it "returns 201 status response for creating a quote" do
        post quote_api_tweet_path(tweet), params: valid_quote_params, headers: @auth_headers
        puts response.body
        
        expect(response).to have_http_status(:created)
      end
  
      it "should create a quote tweet matching json schema" do
        post quote_api_tweet_path(tweet), params: valid_quote_params

        expect(response).to match_response_schema("tweet")
      end
    end

  
    context "with valid parameters" do
      let(:valid_params) { { content: "This is my quote for the tweet" } } # Comentario para citar el tweet
  
      it "creates a new quote tweet" do
        expect {
          post quote_api_tweet_path(tweet.id), params: valid_params, headers: @auth_headers
        }.to change(Tweet, :count).by(1)
      end
  
      it "returns 201 status for successfully quoting the tweet" do
        post quote_api_tweet_path(tweet.id), params: valid_params, headers: @auth_headers
  
        expect(response).to have_http_status(:created)
      end
  
      it "returns the quoted tweet in the response" do
        post quote_api_tweet_path(tweet.id), params: valid_params, headers: @auth_headers
  
        expect(response).to match_response_schema("tweet")
      end
    end
    
  
    context "with invalid parameters" do
      let(:invalid_params) { { content: "" } }  # contenido vacío como un ejemplo inválido
  
      it "does not create a new quote tweet" do
        expect {
          post quote_api_tweet_path(tweet.id), params: invalid_params, headers: @auth_headers
        }.not_to change(Tweet, :count)
      end
  
      it "returns 422 status for unsuccessful quote" do
        post quote_api_tweet_path(tweet.id), params: invalid_params, headers: @auth_headers
  
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

end


    # describe "POST /tweets/:id/retweet" do
    #     let(:tweet) { create(:tweet) }
      
    #     it 'retweets a specific tweet' do
    #       post retweet_api_tweet_path(tweet), headers: @auth_headers
    #       expect(response).to have_http_status(:created)
    #       #expect(response).to match_response_schema("retweet")
    #     end
    # end

    # describe "POST /tweets/:id/quote" do
    #     let(:tweet) { create(:tweet) }
      
    #     it 'quotes a specific tweet' do
    #       post quote_api_tweet_path(tweet), params: { content: "This is a quote!" }, headers: @auth_headers
    #       expect(response).to have_http_status(:created)
    #       #expect(response).to match_response_schema("quote")
    #     end
    # end

    # describe "POST /tweets/:id/bookmark" do
    #     let(:tweet) { create(:tweet) }
      
    #     it 'bookmarks a specific tweet' do
    #       post bookmark_api_tweet_path(tweet), headers: @auth_headers
    #       expect(response).to have_http_status(:created)
    #       #expect(response).to match_response_schema("bookmark")
    #     end
    #   end
  #end