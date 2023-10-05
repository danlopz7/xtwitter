class Api::RegistrationController < Api::AuthenticationController
    
  def create_user
    user = User.new(sign_up_params)

    user.save
    if user
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