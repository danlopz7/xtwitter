require 'json_web_token'

class Api::AuthenticationController < Api::ApiController

  # Excepciones: Si hay controladores o acciones donde no quieres forzar la autenticación,
  # puedes usar skip_before_action
  # no necesitas autenticarte cuando estas creando un usuario
  skip_before_action :authenticate_token!

  def create
    user = User.find_by(email: params[:user][:email])
    if user.valid_password? paramsp[:user][:password]
        render json: {token: JsonWebToken.encode(sub: user.id)}
    else
        render json: {errors: ["Invalid email or password"]}
    end
  end

end