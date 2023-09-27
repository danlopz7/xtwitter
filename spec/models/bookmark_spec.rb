require 'rails_helper'

RSpec.describe Bookmark, type: :model do

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:tweet) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:tweet_id) }
  end

  # Scope tests
  describe ".user_bookmarks" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:tweet) { create(:tweet) }

    before do
      # Create three bookmarks for user1 and one for user2
      create_list(:bookmark, 3, user: user1, tweet: tweet)
      create(:bookmark, user: user2, tweet: tweet)
    end

    it "returns bookmarks belonging to a given user" do
      expect(Bookmark.user_bookmarks(user1.id).count).to eq(3)
      expect(Bookmark.user_bookmarks(user2.id).count).to eq(1)
    end
  end
end
