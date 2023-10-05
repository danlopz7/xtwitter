class Api::SessionsController < Api::AuthenticationController
  
  def create_user_token
    user = User.find_by(email: params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      token = authenticate_user(user)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy_user_token
    current_user.update(jwt_token: nil)
    render json: { message: "Logged out successfully" }, status: :ok
  end
end