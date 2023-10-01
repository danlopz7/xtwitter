require 'rails_helper'

RSpec.describe Follow, type: :model do
  
  context 'associations' do
    it { should belong_to(:follower).class_name('User') }
    it { should belong_to(:followee).class_name('User') }
  end
  
  describe 'validations' do
    subject { build(:follow) } # Create a new follow instance for each test to ensure uniqueness tests

    it { should validate_uniqueness_of(:follower_id).scoped_to(:followee_id).with_message("has already been taken") }
  end
end
