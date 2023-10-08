class Web::UsersController < Web::WebController

  # GET  /web/user/:username  web_user
  def show
    @user = User.find_by(username: params[:username])
  end

  # GET  /web/profile  web_current_user_profile
  def profile
    @user = current_user
  end

  #  GET  /web/user/:username/edit  edit_web_user
  def edit

  end

  private

  def tweet_params
    params.require(:tweet).permit(:id, :body, :classification)
  end

end