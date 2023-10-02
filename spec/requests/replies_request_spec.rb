require 'rails_helper'

RSpec.describe "Replies", type: :request do

  let(:tweet) { create(:tweet) }
  let(:user) { create(:user) }
  let(:valid_reply_params) { { reply: { content: "This is a test reply", user_id: user.id, tweet_id: tweet.id } } }
  let(:invalid_reply_params) { { reply: { content: "", user_id: user.id, tweet_id: tweet.id } } }

  describe "POST /tweets/:id/replies" do
    context "with valid params" do
      it "creates a new reply for the tweet" do
        post tweet_replies_path(tweet), params: valid_reply_params

        expect(response).to have_http_status(201)
        expect(response).to match_response_schema("reply")
      end
    end

    context "with invalid params" do
      it "does not create a reply" do
        post tweet_replies_path(tweet), params: invalid_reply_params

        expect(response).to have_http_status(422)
        expect(response.body).to include("Content can't be blank")
      end
    end
  end
end