class UserController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'

  def show
    @user = User.find(params[:id])
    @photos = @user.photos
  end
end
