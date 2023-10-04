class Api::RegistrationController < Api::ApiController

    
    skip_before_action :authenticate_user!
    
    def create_user
      @user = User.new(user_params)
      @user.save!

      #logic to create token here.. need to pass user.email and password
    end
  
    private

    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
  end
  