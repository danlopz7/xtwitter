class Api::ApiController < ApplicationController

  #attr_reader :current_user
  # we can skip the before action for verify authenticity token
  # the authenticity token thats created every time you make a form and submit that
  # because the way that the rails session cookies need to be secured is with crossside
  # scripting in mind
  skip_before_action :verify_authenticity_token
  
  before_action :set_default_format
  #before_action :authenticate_token!
  before_action :authenticate_user!

  private

  def set_default_format
    request.format = :json
  end

  def render_errors(instance)
    @errors = instance.errors
    @klass = instance.class
    render 'shared/errors', status: :unprocessable_entity
  end
  
end