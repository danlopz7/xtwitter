class Api::AuthenticationController < Api::ApiController

  #skip_before_action :authenticate_user!

  def authenticate_user(user)
    
    if user
      token1 = JsonWebToken.encode(sub: user.id)
      #debugger
      user.update(jwt_token: "#{token1}")
      token
    else
      render json: {errors: ["Something went wrong"]}, status: :unauthorized
    end
  end
end