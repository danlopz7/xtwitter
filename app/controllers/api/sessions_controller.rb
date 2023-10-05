class Api::SessionsController < Api::AuthenticationController
  
  skip_before_action :authenticate_user!
  
  def create_user_token
    user = User.find_by(email: params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      authenticate_user(user)
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy_user_token
    current_user.update(jwt_token: nil)
    render json: { message: "Logged out successfully" }, status: :ok
  end
end