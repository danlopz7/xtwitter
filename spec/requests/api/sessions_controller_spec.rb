require 'rails_helper'

RSpec.describe "API::Sessions", type: :request do

  describe "POST /api/users/sign_in" do
    let(:user) { create(:user) }
    let(:valid_attributes) {
      {
        email: user.email,
        password: 'TestPassword123!'
      }
    }
    let(:invalid_attributes) {
      {
        email: user.email,
        password: 'wrongpassword'
      }
    }

    context "with valid credentials" do
      before { post '/api/users/sign_in', params: valid_attributes }

      it "returns an authentication token" do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["token"]).not_to be_nil
      end
    end

    context "with invalid credentials" do
      before { post '/api/users/sign_in', params: invalid_attributes }

      it "returns an error message" do
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Invalid email or password")
      end
    end
  end

  describe "DELETE /api/users/sign_out" do
    let(:user) { create(:user) }
    let(:login_params) {
      {
        user: {
          email: user.email,
          password: 'TestPassword123!'
        }
      }
    }
  
    context "when user is signed in" do
      before do
        # Primero, realizamos una petición de inicio de sesión
        post '/api/users/sign_in', params: login_params
        token = JSON.parse(response.body)["token"]
  
        # Luego, utilizamos el token para la petición de cierre de sesión
        headers = { "Authorization" => "Bearer #{token}" }
        delete '/api/users/sign_out', headers: headers
      end
  
      it "revokes user's token" do
        user.reload
        expect(user.jwt_token).to be_nil
      end
  
      it "returns a success message" do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Logged out successfully")
      end
    end
  end
end