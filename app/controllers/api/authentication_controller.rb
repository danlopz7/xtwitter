class Api::AuthenticationController < Api::ApiController

  skip_before_action :authenticate_user!

  def authenticate_user(user)
    return render json: {errors: ["Invalid user"]}, status: :unauthorized unless user

    token = JsonWebToken.encode(sub: user.id)
    user.update_attribute(:jwt_token, "#{token}")
    puts token
    token
  end
end