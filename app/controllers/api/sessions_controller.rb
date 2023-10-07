class Api::SessionsController < Api::AuthenticationController

  skip_before_action :authenticate_user!
  
  def create_user_token
    user = User.find_by(email: sign_in_params[:email])

    if user&.valid_password?(sign_in_params[:password])
      token = authenticate_user(user)
      #debugger
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy_user_token
    # extraemos el token que recibo a traves del header headers = { "Authorization" => "Bearer #{token}" }
    token = request.headers['Authorization'].split(' ').last
    decoded_token = JsonWebToken.decode(token)
    user_id = decoded_token["sub"]
    user = User.find(user_id)
    user.update_attribute(:jwt_token, nil)
    #user.update(jwt_token: nil)

    render json: { message: "Logged out successfully" }, status: :ok
  end

  private

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end
end

# localhost:3000/api/users/sign_out
# En postman poner el header asi: Authorization Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjQsImV4cCI6MTY5NjY1MDI2N30.oztPvyDbAJfzJvOX-gUlejEdgMYOk3XFzkSVWtO6U9I