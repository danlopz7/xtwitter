require 'rails_helper'

RSpec.describe User, type: :model do

  # Creando una instancia de User usando FactoryBot
  let(:user) { create(:user) }

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:lastname) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('valid_Password123').for(:password).with_message("Your password is correct")}
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

  
end
