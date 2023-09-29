require 'rails_helper'

RSpec.describe "Tweets", type: :request do

  let(:user) { create(:user) }
  let(:tweet) { create(:tweet, user: user) }

  describe "POST /tweets" do
    let(:valid_params) { { tweet: { content: "This is a tweet.", user_id: user.id } } }
    let(:invalid_params) { { tweet: { content: "", user_id: user.id } } }

    context "with valid params" do
      it "creates a new tweet" do
        post tweets_path, params: valid_params

        expect(response).to have_http_status(201)
        expect(response).to match_response_schema("tweet")
      end
    end

    context "with invalid params" do
      it "does not create a new tweet" do
        post tweets_path, params: invalid_params

        expect(response).to have_http_status(422)
        expect(response.body).to include("Content can't be blank")
      end
    end
  end


  describe "PUT /tweets/:id" do
    let(:valid_update_params) { { tweet: { content: "This is an updated tweet." } } }
    let(:invalid_update_params) { { tweet: { content: "" } } }

    context "with valid params" do
      it "updates the tweet" do
        put tweet_path(tweet), params: valid_update_params

        expect(response).to have_http_status(200)
        expect(tweet.reload.content).to eq("This is an updated tweet.")
        expect(response).to match_response_schema("tweet")
      end
    end

    context "with invalid params" do
      it "does not update the tweet" do
        put tweet_path(tweet), params: invalid_update_params

        expect(response).to have_http_status(422)
        expect(response.body).to include("Content can't be blank")
      end
    end
  end

  describe "POST /tweets/:id/quote" do
    let(:valid_quote_params) { { tweet: { content: "This is a quote.", original_tweet_id: tweet.id, user_id: user.id } } }
    let(:invalid_quote_params) { { tweet: { content: "", original_tweet_id: tweet.id, user_id: user.id } } }

    context "with valid params" do
      it "creates a quote tweet" do
        post quote_tweet_path(tweet), params: valid_quote_params

        expect(response).to have_http_status(201)
        expect(response).to match_response_schema("tweet")
      end
    end

    context "with invalid params" do
      it "does not create a quote tweet" do
        post quote_tweet_path(tweet), params: invalid_quote_params

        expect(response).to have_http_status(422)
        expect(response.body).to include("Content can't be blank")
      end
    end
  end

  describe "POST /tweets/:id/retweet" do
    context "with valid params" do
      it "retweets the tweet" do
        post retweet_tweet_path(tweet)

        expect(response).to have_http_status(201)
        expect(response).to match_response_schema("tweet")
      end
    end

    context "with invalid params" do
      # Supongamos en el controller la lógica impide que un usuario retweetee un tweet más de una vez.
      before do
        user.retweets.create(original_tweet: tweet)
      end

      it "does not retweet again" do
        post retweet_tweet_path(tweet)

        expect(response).to have_http_status(422)
        expect(response.body).to include("Tweet has already been retweeted by the user")
      end
    end
  end
  

  describe "POST /tweets/:id/like" do
    it "likes the tweet" do
      post like_tweet_path(tweet.id)

      expect(response.status).to have_http_status(200)
      expect(response).to match_response_schema("like")
    end
  end

  describe "DELETE /tweets/:id/unlike" do
    it "unlikes the tweet" do
      delete unlike_tweet_path(tweet.id)

      expect(response.status).to have_http_status(200)
      #expect(response).to match_response_schema("tweet")
    end
  end


  describe "POST /tweets/:id/bookmark" do
    it "bookmarks the tweet" do
      post bookmark_tweet_path(tweet.id)

      expect(response.status).to have_http_status(200)
      expect(response).to match_response_schema("bookmark")
    end
  end

  describe "DELETE /tweets/:id/unbookmark" do
    it "removes bookmark from the tweet" do
      delete unbookmark_tweet_path(tweet.id)

      expect(response.status).to have_http_status(200)
      #expect(response).to match_response_schema("tweet")
    end
  end


  describe "GET /tweets/:id/stats" do
    it "returns tweet statistics" do
      get stats_tweet_path(tweet.id)

      expect(response.status).to have_http_status(200)
      expect(response).to match_response_schema("tweet_stats")
    end
  end
end