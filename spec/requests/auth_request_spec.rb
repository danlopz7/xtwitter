require 'rails_helper'

RSpec.describe "Api::Authentication", type: :request do
    let(:user) { create(:user) } # Usando FactoryBot para crear un usuario
  
    describe "POST /api/log_in" do
      context "with valid params" do
        it "authenticates the user and returns a token" do
          # Haciendo la petición POST con el id del usuario y su contraseña
          post api_log_in_path, params: { id: user.id, password: user.password }
  
          # Esperamos obtener una respuesta HTTP 200 (OK)
          expect(response).to have_http_status(:ok)
  
          # Parseamos la respuesta como JSON
          json_response = JSON.parse(response.body)
  
          # Verificamos que el JSON tenga una clave 'token'
          expect(json_response).to have_key('token')
        end
      end   
  
      context "with invalid params" do
        it "does not authenticate the user when password is wrong" do
          post api_log_in_path, params: { id: user.id, password: 'wrongpassword' }
  
          expect(response).to have_http_status(:unauthorized)
          json_response = JSON.parse(response.body)
          expect(json_response['errors']).to include("Invalid email or password")
        end
  
        it "does not authenticate the user when id is wrong" do
          post api_log_in_path, params: { id: -1, password: user.password }
  
          expect(response).to have_http_status(:unauthorized)
          json_response = JSON.parse(response.body)
          expect(json_response['errors']).to include("Invalid email or password")
        end
      end
    end
  end