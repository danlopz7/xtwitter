class Api::AuthenticationController < Api::ApiController

  # Excepciones: Si hay controladores o acciones donde no quieres forzar la autenticación, 
  # puedes usar skip_before_action
  # no necesitas autenticarte cuando estas creando un usuario
  skip_before_action :authenticate_user!

  def create
    user = User.find_by(id: params[:id])
    if user.valid_password? params[:password]
        render json: {token: JsonWebToken.encode(sub: user.id)}
    else
        render json: {errors: ["Invalid email or password"]}
    end
  end

end