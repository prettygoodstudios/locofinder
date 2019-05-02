class PhotoController < ActionController::Base
  layout 'application'
  before_action :set_photo, only: [:destroy, :show]
  before_action :is_mine_or_admin, only: [:destroy]
  before_action :is_logged_in, only: [:new, :create]
  def create
    @location = Location.find(params[:photo][:location].to_i)
    @user = User.find(params[:photo][:user].to_i)
    @photo = @location.photos.build(photo_params)
    @user.photos << @photo
    if @photo.save
      @photo.update_attribute("views",0)
      @photo.update_attribute("width",@photo.img_url.width)
      @photo.update_attribute("height",@photo.img_url.height)
      redirect_to @location, alert: "Successfully Posted!"
    else
      redirect_to new_photo_path+"/?user=#{@user.id}&location=#{@location.id}", alert: @photo.errors.first
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
  def show
    @photo.update_attribute("views",@photo.views+1)
  end
  def collection_api
    @collection = nil
    @users = nil
    @locations = nil
    if params[:user] != nil
      @collection = User.find(params[:user]).photos.mostViews
      user = User.find(params[:user])
      @users = Array.new(@collection.length) { |x| user }
      @locations = Location.joins(:photos).where("photos.user_id=#{params[:user]}").order("photos.views DESC")
    else
      @collection = Location.find(params[:location]).photos.mostViews
      location = Location.find(params[:location])
      @locations = Array.new(@collection.length) { |x| location }
      @users = User.joins(:photos).where("photos.location_id=#{params[:location]}").order("photos.views DESC")
    end
    render json: @collection.zip(@users,@locations)
  end
  def photo_params
    params.require(:photo).permit(:img_url,:caption,:width,:height,:zoom,:offsetX,:offsetY)
  end
  def set_photo
    @photo = Photo.where("slug = '#{params[:id]}'").first
  end
  def is_logged_in
    if !signed_in?
      redirect_to location_index_path, alert: "You must be logged in to perform this action."
    elsif !current_user.verified
      redirect_to "/user/disabled_account/#{current_user.id}", alert: "You must verify you email to perform this action."
    end
  end
  def is_mine_or_admin
    if signed_in?
      if current_user.id != @photo.user_id
        redirect_to location_index_path, alert: "You must own or be an admin to access this content."
      elsif !current_user.verified and current_user.role != "admin"
        redirect_to "/user/disabled_account/#{current_user.id}", alert: "You must verify you email to perform this action."
      end
    else
      redirect_to location_index_path, alert: "You must be signed in to access this content."
    end
  end
end
