class Api::ApiController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  #attr_reader :current_user
  # we can skip the before action for verify authenticity token
  # the authenticity token thats created every time you make a form and submit that
  # because the way that the rails session cookies need to be secured is with crossside
  # scripting in mind
  #before_action :verify_authenticity_token
  
  before_action :set_default_format
  #before_action :authenticate_token!
  before_action :authenticate_user!
  #before_action { authenticate_user!( force: true ) }


  private

  def set_default_format
    request.format = :json unless params[:format]
  end

  def record_not_found
    render json: { error: "Record not found" }, status: :not_found
  end

  def render_errors(instance)
    @errors = instance.errors
    @klass = instance.class
    render 'shared/errors', status: :unprocessable_entity
  end
  
end