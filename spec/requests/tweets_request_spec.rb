require 'rails_helper'

RSpec.describe "Tweets", type: :request do

  describe "POST /tweets" do
    let(:user) { create(:user) }
    let(:valid_params) { { tweet: { content: "This is a tweet.", user_id: user.id } } }
    let(:invalid_params) { { tweet: { content: "", user_id: user.id } } }

    context "with valid params" do
      it 'returns 201 status response for creating a new tweet' do
        post tweets_path, :params => valid_params
        puts response.body

        expect(response).to have_http_status(:created)
      end

      it "should create a new tweet matching json schema" do
        post tweets_path, params: valid_params
        #Rails.logger.debug response.body
        
        expect(response).to match_response_schema("tweet")
      end
    end

    context "with invalid params" do
      it "does not create a new tweet" do
        post tweets_path, params: invalid_params
        puts response.body

        expect(response).to have_http_status(422)
      end
    end
  end


  describe "PUT /tweets/:id" do
    let(:original_tweet_content) { "Original content" }
    let(:updated_tweet_content) { "This is an updated tweet." }
    let(:empty_tweet_content) { "" }

    before do
      @tweet = create(:tweet, content: original_tweet_content)
    end

    context "with valid params" do
      it 'returns 200 status response for updating a tweet' do
        # La instancia se ha guardado con el contenido original
        expect(@tweet.content).to eq(original_tweet_content)
        puts @tweet.as_json

        # Actualizar el tweet
        put tweet_path(@tweet), params: { tweet: { content: updated_tweet_content } }

        # Recuperar el tweet de la base de datos y comprobar que ha sido actualizado
        @updated_tweet = Tweet.find(@tweet.id)
        puts @updated_tweet.as_json
        expect(@updated_tweet.content).to eq(updated_tweet_content)

        # Asegurar que la respuesta es la esperada
        expect(response).to have_http_status(:ok)
      end

      it "should update a tweet matching json schema" do
        put tweet_path(@tweet), params: { tweet: { content: updated_tweet_content } }

        expect(response).to match_response_schema("tweet")
      end
    end

    context "with invalid params" do
      it "does not update a tweet" do
        put tweet_path(@tweet), params: { tweet: { content: empty_tweet_content } }
  
        # Recuperar el tweet de la base de datos y comprobar que no ha sido actualizado
        @updated_tweet = Tweet.find(@tweet.id)
        expect(@updated_tweet.content).not_to eq(empty_tweet_content)
  
        # Asegurar que la respuesta es la esperada
        expect(response).to have_http_status(422)
      end
    end
  end


  describe "POST /tweets/:id/quote" do
    let!(:user) { create(:user) }
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
        puts tweet.as_json
        post quote_tweet_path(tweet), params: valid_quote_params
        puts response.body
        
        expect(response).to have_http_status(:created)
      end
  
      it "should create a quote tweet matching json schema" do
        post quote_tweet_path(tweet), params: valid_quote_params
        expect(response).to match_response_schema("tweet")
      end
    end
  
    context "with invalid params" do
      it "does not create a quote tweet" do
        post quote_tweet_path(tweet), params: invalid_quote_params
        expect(response).to have_http_status(422)
      end
    end
  end


  describe "POST /tweets/:id/retweet" do
    let!(:user) { create(:user) } # Crea un usuario usando la fábrica
    let!(:tweet) { create(:tweet) } # Crea un tweet usando la fábrica

    context "with valid params" do
        it "returns 201 status response for creating a retweet" do
            puts tweet.as_json
            post retweet_tweet_path(tweet.id), params: { user_id: user.id }
            puts response.body

            expect(response).to have_http_status(:created)
        end

        it "should create a retweet matching json schema" do
            post retweet_tweet_path(tweet.id), params: { user_id: user.id }
            expect(response).to match_response_schema("tweet")
        end
    end

    context "with invalid params" do
        it "does not retweet again" do
            # Retweet once
            post retweet_tweet_path(tweet.id), params: { user_id: user.id }
            expect(response).to have_http_status(:created)

            # Try to retweet again
            post retweet_tweet_path(tweet.id), params: { user_id: user.id }
            expect(response).to have_http_status(422)
        end
    end
  end


  describe "POST /tweets/:id/like" do
    let(:user) { create(:user) }
    let(:tweet) { create(:tweet) } 

    it "likes the tweet" do
      post like_tweet_path(tweet.id), params: { user_id: user.id }

      expect(response).to have_http_status(:ok)

      expect(response).to match_response_schema("like")
    end

    context "when the user has already liked the tweet" do
        before do
            Like.create(user: user, tweet: tweet)
        end

        it "does not create another like" do
            post like_tweet_path(tweet.id), params: { user_id: user.id }

            expect(response).to have_http_status(422)
            parsed_response = JSON.parse(response.body)
            expect(parsed_response["errors"]).to include("You've already liked this tweet.")
        end
    end
  end
  

  describe "DELETE /tweets/:id/unlike" do
    let!(:user) { create(:user) }
    let!(:tweet) { create(:tweet, user: user) }
    let!(:like) { create(:like, user: user, tweet: tweet) }  # Ensure the tweet is liked initially.

    context "when the tweet has been liked" do
        it "unlikes the tweet" do
          delete unlike_tweet_path(tweet.id)

          expect(response).to have_http_status(200)
        end
    end

    context "when the tweet hasn't been liked yet" do
        before do
            like.destroy  # Remove the like to mimic the scenario.
        end

        it "returns an error status" do
          delete unlike_tweet_path(tweet.id)

          expect(response).to have_http_status(:unprocessable_entity)
        end
    end
  end


  describe "POST /tweets/:id/bookmark" do
    let(:user) { create(:user) }
    let(:tweet) { create(:tweet) }
  
    context "when a user bookmarks a tweet" do
      it "bookmarks the tweet" do
        post bookmark_tweet_path(tweet.id, user_id: user.id)
  
        expect(response).to have_http_status(200)
        expect(response).to match_response_schema("bookmark")
      end
  
      context "when the tweet is already bookmarked by the user" do
        before do
          # Create an initial bookmark
          create(:bookmark, user: user, tweet: tweet)
        end
  
        it "does not bookmark the tweet again" do
          post bookmark_tweet_path(tweet.id, user_id: user.id)
  
          expect(response).to have_http_status(422)
          json_response = JSON.parse(response.body)
          expect(json_response["errors"]).to include("You've already bookmarked this tweet.")
        end
      end
    end
  end

  
  describe "DELETE /tweets/:id/unbookmark" do
    let(:user) { create(:user) }
    let(:tweet) { create(:tweet) }
  
    context "when the tweet has been bookmarked" do
      before do
        # Create an initial bookmark
        create(:bookmark, user: user, tweet: tweet)
      end
  
      it "unbookmarks the tweet" do
        delete unbookmark_tweet_path(tweet.id, user_id: user.id)
  
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Bookmark removed")
      end
    end
  
    context "when the tweet hasn't been bookmarked" do
      it "returns an error" do
        delete unbookmark_tweet_path(tweet.id, user_id: user.id)
  
        expect(response).to have_http_status(422)
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Bookmark not found or could not be deleted")
      end
    end
  end
end