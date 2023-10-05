class Api::SessionsController < Api::AuthenticationController
  
  def create_user_token
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      
      token = authenticate_user(user)
      #debugger
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy_user_token
    token = params[:token]
    decoded_token = JsonWebToken.decode(token)
    user_id = decoded_token["sub"] 
    user = User.find(user_id)
    user.update(jwt_token: nil)
    render json: { message: "Logged out successfully" }, status: :ok
  end
end