class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) do |user|
        user.permit(:name, :email, :password, :password_confirmation, :bio, :profile_img)
      end
      devise_parameter_sanitizer.permit(:account_update) do |user|
        user.permit(:name, :email, :bio, :current_password, :profile_img)
      end
    end
end
