class AdminController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  before_action :is_admin, only: [:index]
  def index
    @top_users = User.all.index_sort.first(10)
    @top_photos = Photo.all.mostViews.first(10)
  end
  def is_logged_in
    if signed_in?
      if !current_user.verified
        redirect_to location_index_path, alert: "You must verify your account to report content."
      end
    else
      redirect_to location_index_path, alert: "You must be signed in to report content."
    end
  end
  def is_admin
    if signed_in?
      if current_user.role != "admin"
        redirect_to location_index_path, alert: "You must be an admin to access this content."
      end
    else
      redirect_to location_index_path, alert: "You must be an admin to access this content."
    end
  end
end
