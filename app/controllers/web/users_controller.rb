class Web::UsersController < Web::WebController

  def index
    @tweets = Tweet.all
    render_response('web/tweets/index')
  end

  private

  def tweet_params
    params.require(:tweet).permit(:id, :body, :classification)
  end

end