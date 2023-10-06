require 'rails_helper'

RSpec.describe "API::Registration", type: :request do

    let(:valid_attributes) { attributes_for(:user) }
    let(:invalid_attributes) { { user: { email: "test@test.com", password: "12345", password_confirmation: "54321" } } }
  
    context "with valid parameters" do
        it "creates a new User" do
          expect {
            post api_new_user_registration_path, params: { user: valid_attributes }
          }.to change(User, :count).by(1)
        end
    
        it "returns a JSON with authentication token" do
          post api_new_user_registration_path, params: { user: valid_attributes }
          
          expect(response).to have_http_status(:ok)
          json = JSON.parse(response.body)
          expect(json['token']).to be_present
        end
    end
      
      context "with invalid parameters" do
        it "does not create a new User" do
          expect {
            post api_new_user_registration_path, params: { user: invalid_attributes }
          }.to change(User, :count).by(0)
        end
    
        it "returns an error message" do
          post api_new_user_registration_path, params: { user: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          json = JSON.parse(response.body)
          expect(json['errors']).to eq("Invalid email or password")
        end
    end
end