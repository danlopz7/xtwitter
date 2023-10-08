class Web::RegistrationsController < Devise::RegistrationsController

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]


  protected

  def after_sign_up_path_for(resource)
    web_root_path
  end

    
   def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end


  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

end