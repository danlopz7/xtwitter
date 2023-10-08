class Api::RegistrationController < Api::AuthenticationController

  skip_before_action :authenticate_user!
    
  def create_user
    user = User.new(sign_up_params)
    user.save

    if user.persisted?
      token = authenticate_user(user)
      render json: { token: token }, status: :ok
    else
      render json: { errors: "Invalid email or password" }, status: :unprocessable_entity
    end
  end
  
  private

  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end