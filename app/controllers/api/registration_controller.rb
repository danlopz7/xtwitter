class Api::RegistrationController < Api::AuthenticationController
    
  skip_before_action :authenticate_user!
    
  def create_user
    user = User.new(sign_up_params)

    if user.save
      authenticate_user(user)
    else
      render json: { errors: "Invalid email or password" }, status: :unprocessable_entity
    end
  end
  
  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end