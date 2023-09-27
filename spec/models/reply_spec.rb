require 'rails_helper'

RSpec.describe Reply, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(255) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:tweet) }
  end

  # Test para validar la creación de un reply
  it 'is valid with valid attributes' do
    reply = build(:reply)
    expect(reply).to be_valid
  end

  it 'is not valid without content' do
    reply = build(:reply, content: nil)
    expect(reply).not_to be_valid
  end
end
