require 'json_web_token'

class Api::ApiController < ApplicationController

  #attr_reader :current_user
  # we can skip the before action for verify authenticity token
  # the authenticity token thats created every time you make a form and submit that
  # because the way that the rails session cookies need to be secured is with crossside
  # scripting in mind
  skip_before_action :verify_authenticity_token
  
  before_action :set_default_format
  before_action :authenticate_token!

  private

  def set_default_format
    request.format = :json
  end

  def authenticate_token!
    # Implementa tu lógica de autenticación aquí
    # Si el usuario no está autenticado, puedes responder con un error, por ejemplo:
    # render json: { error: "Not authorized" }, status: :unauthorized unless <tu_condicion_de_autenticación>
    payload = JsonWebToken.decode(auth_token)
    @current_user = User.find(payload["sub"])
    rescue JWT::ExpiredSignature
      render json: {errors: ["Auth token has expired"]}, status: :unauthorized
    recue JWT::DecodeError
      render json: {errors: ["Invalid auth token"]}, status: :unauthorized 
  end

  def auth_token!
    @auth_token ||= request.headers.fetch("Authorization", "").split(" ").last
  end

  def render_errors(instance)
    @errors = instance.errors
    @klass = instance.class
    render 'shared/errors', status: :unprocessable_entity
  end
  
end