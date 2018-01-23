class PhotoController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
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
    @photo = Photo.find(params[:id])
    @photo.destroy!
    redirect_to Location.find(@photo.location_id)
  end
  def photo_params
    params.require(:photo).permit(:img_url,:caption)
  end
end
