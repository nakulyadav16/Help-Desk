class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters,if: :devise_controller?

  protected
  def after_sign_in_path_for(resource)
    if current_user.roles.first != nil and current_user.roles.first.name =="admin"
        home_path
    else
        tickets_path
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:name ,:dob ,:contact,:department_id,:role])
    devise_parameter_sanitizer.permit(:account_update, keys:[:name ,:dob ,:contact,:department_id,:role])
  end


end
