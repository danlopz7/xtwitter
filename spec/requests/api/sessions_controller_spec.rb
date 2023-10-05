require 'rails_helper'

RSpec.describe "API::Sessions", type: :request do

    describe "POST /api/users/sign_in" do
      let(:user) { create(:user, password: 'password123') } # Asumiendo que tienes una factory para User
      let(:valid_attributes) do
        { user: { email: user.email, password: 'password123' } }
      end
  
      context "with valid credentials" do
        it "returns an authentication token" do
          post '/api/users/sign_in', params: valid_attributes
          expect(response.body).to include('token')
        end
      end
  
      # Puedes agregar más contextos, como para credenciales inválidas, etc.
    end
  
    describe "DELETE /api/users/sign_out" do
      let(:user) { create(:user) }
      before { sign_in user } # Usando el helper de Devise
  
      it "revokes user's token" do
        delete '/api/users/sign_out'
        user.reload
        expect(user.jwt_token).to be_nil
      end
    end
  end