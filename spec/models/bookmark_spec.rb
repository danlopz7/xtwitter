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
end
