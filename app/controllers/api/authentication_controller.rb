class Api::AuthenticationController < Api::ApiController

  skip_before_action :authenticate_user!

  def authenticate_user(user)
    if user
      token = JsonWebToken.encode(sub: user.id)
      user.update(jwt_token: "#{token}")
      token
    else
      render json: {errors: ["Something went wrong"]}, status: :unauthorized
    end
  end
end