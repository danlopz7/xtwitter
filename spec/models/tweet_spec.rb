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
    it { should have_many(:bookmarks).dependent(:destroy) }
    it { should have_many(:bookmarkers) }
    it { should have_many(:replies).class_name('Reply') }
    it { should have_and_belong_to_many(:hashtags) }
  end

  describe 'validations' do
    it { should validate_presence_of(:content).if(:tweet_or_quote?) }
    it { should validate_length_of(:content).is_at_most(255).if(:tweet_or_quote?) }
  end

  
end
