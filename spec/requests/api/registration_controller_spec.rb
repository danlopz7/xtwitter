require 'rails_helper'

RSpec.describe "API::Registration", type: :request do

  
    describe "POST /api/users/sign_up" do
        let(:valid_attributes) do
          { user: { email: 'test@example.com', password: 'password123', password_confirmation: 'password123' } }
        end
    
        context "with valid parameters" do
          it "creates a new user" do
            expect {
              post '/api/users/sign_up', params: valid_attributes
            }.to change(User, :count).by(1)
          end
    
          it "returns a new authentication token" do
            post '/api/users/sign_up', params: valid_attributes
            expect(response.body).to include('token')
          end
        end
    
    end


end