require 'rails_helper'

RSpec.describe Tweet, type: :model do

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:original_retweet).class_name('Tweet').optional }
    it { should belong_to(:original_quote).class_name('Tweet').optional }
    it { should have_many(:retweets).class_name('Tweet').dependent(:destroy) }
    it { should have_many(:quotes).class_name('Tweet').dependent(:destroy) }
    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:likers) }
    it { should have_many(:bookmarks)}
    it { should have_many(:replies).class_name('Reply') }
    it { should have_and_belong_to_many(:hashtags) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content).if(:tweet_or_quote?) }
    it { should validate_length_of(:content).is_at_most(255).if(:tweet_or_quote?) }
  end

  describe 'scopes' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:tweet) { create(:tweet, user: user) }

    before do
      create_list(:tweet, 3, user: user)
      create_list(:retweet, 4, original_retweet: tweet)
      create_list(:quote, 3, original_quote: tweet)
      
      # Crear replies para el usuario
      tweet_from_another_user = create(:tweet, user: another_user)
      create(:reply, user: user, tweet: tweet_from_another_user)
    end

    describe '.user_tweets' do
      it 'returns tweets created by the user' do
        # 4 tweets, one created by defining let and three more
        tweets = Tweet.user_tweets(user.id)
        expect(tweets.count).to eq(4)
        expect(tweets.first.user_id).to eq(user.id)
      end
    end

    describe '.user_tweets_and_replies' do
      it 'returns tweets and replies from the user' do
        results = Tweet.user_tweets_and_replies(user.id)

        # 4 tweets + 1 reply
        expect(results.count).to eq(5)
        expect(results.where(user_id: user.id).count).to eq(4)
        expect(results.joins(:replies).where(replies: { user_id: user.id }).count).to eq(1)
      end
    end

    describe '.retweets_count' do
      it 'returns the number of retweets for a specific tweet' do
        count = Tweet.retweets_count(tweet.id)
        expect(count).to eq(4)
      end
    end

    describe '.quotes_count' do
      it 'returns the number of quotes for a specific tweet' do
        count = Tweet.quotes_count(tweet.id)
        expect(count).to eq(3)
      end
    end
  end
end
