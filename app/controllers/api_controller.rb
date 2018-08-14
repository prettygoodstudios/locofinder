class ApiController < ActionController::Base
  #protect_from_forgery with: :exception
  before_action :set_default_format

  before_action :configure_permitted_parameters, if: :devise_controller?
  def default_url_options(options={})
   { :protocol => "https" }
  end

  private
    def set_default_format
      request.format :json
    end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) do |user|
        user.permit(:display, :name, :email, :password, :password_confirmation, :bio, :profile_img, :height, :width, :offsetX, :offsetY, :zoom)
      end
      devise_parameter_sanitizer.permit(:account_update) do |user|
        user.permit(:display, :name, :email, :bio, :current_password, :profile_img, :height, :width, :offsetX, :offsetY, :zoom)
      end
    end
end
