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
    it { should validate_presence_of(:user)}
    it { should validate_length_of(:content).is_at_most(255) }
  end

  describe 'methods' do
    describe "#retweet" do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet) } # Crear un tweet de otro usuario

      context "when the user has not retweeted the tweet" do
        it "allows the user to retweet" do
          expect(user.has_retweeted?(tweet)).to be_falsey
          puts user.as_json
          expect(tweet.retweet(user)).to be_truthy
          puts tweet.user.as_json
          expect(user.has_retweeted?(tweet)).to be_truthy
        end
      end

      context "when the user has already retweeted the tweet" do
        before do
          create(:tweet, user: user, retweet_id: tweet.id) # El usuario ya ha retuiteado este tweet
        end

        it "does not allow the user to retweet again" do
          expect(user.has_retweeted?(tweet)).to be_truthy
          expect(tweet.retweet(user)).to be_falsey
        end
      end
   end
  
    describe "#quote_tweet" do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet) } # Un tweet que será citado
    
      context "with valid text body" do
        let(:quote_body) { "This is a quote from the original tweet ." }

        it "allows the user to quote the tweet" do
          quoted_tweet = tweet.quote_tweet(user, quote_body)
        
          expect(quoted_tweet).not_to be_nil
          expect(quoted_tweet.content).to eq(quote_body)
          expect(quoted_tweet.user_id).to eq(user.id)
          expect(quoted_tweet.quote_id).to eq(tweet.id)
        end
      end

      context "with blank text body" do
        let(:quote_body) { "" }

        it "does not allow the user to quote the tweet" do
          quoted_tweet = tweet.quote_tweet(user, quote_body)
          expect(quoted_tweet).to be_nil
        end
      end
    end

    describe "#like" do
      let(:user) { create(:user) }
      let(:tweet) { create(:tweet) }

      context "when the user has not liked the tweet before" do
        it "allows the user to like the tweet" do
          expect(tweet.like(user)).to be_truthy

          # Verificar que el usuario efectivamente le dio "like" al tweet
          expect(user.has_liked?(tweet)).to be_truthy
        end
      end

      context "when the user has already liked the tweet" do
        before do
          tweet.like(user) # Hacemos que el usuario le dé "like" al tweet
        end

        it "does not allow the user to like the tweet again" do
          expect(tweet.like(user)).to be_falsey

          # Esperamos que solo haya un "like" del usuario al tweet
          expect(Like.where(user_id: user.id, tweet_id: tweet.id).count).to eq(1)
        end
      end
    end

    describe "#create_hashtags_from_content" do
      context "when the tweet contains new hashtags" do
        let(:tweet) { build(:tweet, content: "This is a new tweet with #hashtag1 and #hashtag2") }

        it "creates and associates the hashtags with the tweet" do
          expect{ tweet.create_hashtags_from_content }.to change{ Hashtag.count }.by(2)

          expect(tweet.hashtags.map(&:name)).to include("hashtag1", "hashtag2")
        end
      end

      context "when the tweet contains an existing hashtag" do
        let!(:existing_hashtag) { Hashtag.create(name: "existinghashtag") }
        let(:tweet) { build(:tweet, content: "This is a tweet with #existinghashtag and #newhashtag") }

        it "associates the existing hashtag and creates new ones" do
          expect{ tweet.create_hashtags_from_content }.to change{ Hashtag.count }.by(1)

          expect(tweet.hashtags.map(&:name)).to include("existinghashtag", "newhashtag")
        end
      end

      context "when the tweet does not contain hashtags" do
       let(:tweet) { build(:tweet, content: "This is a tweet without hashtags") }

        it "does not create any hashtags" do
          expect{ tweet.create_hashtags_from_content }.not_to change{ Hashtag.count }
        end
      end
    end
  end

  describe 'scopes' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:tweet) { create(:tweet, user: user) }

    before do
      # create_list(:tweet, 3, user: user)
      # create_list(:retweet, 4, original_retweet: tweet)
      # create_list(:quote, 3, original_quote: tweet)
      create_list(:tweet, 3, user: user)
      create_list(:tweet, 4, :retweet, original_retweet: tweet)
      create_list(:tweet, 3, :quote, original_quote: tweet)
      
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
