class Api::ApiController < ApplicationController

    before_action :authenticate_api_user!

    private

  def authenticate_api_user!
    # Implementa tu lógica de autenticación aquí
    # Si el usuario no está autenticado, puedes responder con un error, por ejemplo:
    # render json: { error: "Not authorized" }, status: :unauthorized unless <tu_condicion_de_autenticación>
  end

  def render_errors(instance)
    @errors = instance.errors
    @klass = instance.class
    render 'shared/errors', status: :unprocessable_entity
  end
  
end