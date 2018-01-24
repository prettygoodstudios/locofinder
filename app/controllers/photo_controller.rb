class PhotoController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  before_action :set_photo, only: [:destroy]
  before_action :is_mine_or_admin, only: [:destroy]
  before_action :is_logged_in, only: [:new, :create]
  def create
    @location = Location.find(params[:photo][:location].to_i)
    @user = User.find(params[:photo][:user].to_i)
    @photo = @location.photos.build(photo_params)
    @user.photos << @photo
    if @photo.save
      redirect_to @location
    else
      redirect_to new_photo_path, alert: @photo.errors.first
    end
  end
  def new
    @location = Location.find(params[:location].to_i)
    @user = User.find(params[:user].to_i)
    @photo = Photo.new
  end
  def destroy
    @photo.destroy!
    redirect_to Location.find(@photo.location_id)
  end
  def photo_params
    params.require(:photo).permit(:img_url,:caption)
  end
  def set_photo
    @photo = Photo.find(params[:id])
  end
  def is_logged_in
    if !signed_in?
      redirect_to location_index_path, alert: "You must be logged in to perform this action."
    end
  end
  def is_mine_or_admin
    if signed_in?
      if current_user.id != Photo.find(params[:id]).user_id
        redirect_to location_index_path, alert: "You must own or be an admin to access this content."
      end
    else
      redirect_to location_index_path, alert: "You must be signed in to access this content."
    end
  end
end
