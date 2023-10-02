require 'rails_helper'
RSpec.describe User, type: :model do
  
  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should allow_value('valid_Password123').for(:password)}
    it { should validate_length_of(:password).is_at_least(12)}
  end
  
  describe 'associations' do
    it { should have_many(:tweets) }
    it { should have_many(:retweets) }
    it { should have_many(:followers) }
    it { should have_many(:followees) }
    it { should have_many(:likes) }
    it { should have_many(:bookmarks) }
    it { should have_many(:replies) }
  end

  describe 'scopes' do
    # Creando instancias de User usando FactoryBot
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    
    describe ':followers_count' do
      before do
        create(:follow, follower: another_user, followee: user)
      end

      it 'returns the number of followers a user has' do
        expect(User.followers_count(user.id)).to eq(1)
      end
    end

    describe ':following_count' do
      before do
        create(:follow, follower: user, followee: another_user)
      end

      it 'returns the number of users a user follows' do
        expect(User.following_count(user.id)).to eq(1)
      end
    end
  end
end