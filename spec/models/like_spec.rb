require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:tweet) }
  end
  
  describe 'uniqueness validation' do
    subject { FactoryBot.create(:like) }
    it { should validate_uniqueness_of(:tweet_id).scoped_to(:user_id) }
  end
end
