class LocationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  before_action :set_location, only: [:show,:edit,:update,:destroy]
  before_action :is_mine_or_admin, only: [:edit,:update,:destroy]
  before_action :is_logged_in, only: [:new,:create]
  def index
    @locations = Location.all
  end
  def show
    @reviews = @location.reviews.all
    @review = Review.new
    @friendly_address = ""
    @location.address.split(" ").each do |m|
      @friendly_address += m + "+"
    end
    @location.city.split(" ").each do |m|
      @friendly_address += m + "+"
    end
    @location.state.split(" ").each do |m|
      @friendly_address += m + "+"
    end
    @location.country.split(" ").each do |m|
      @friendly_address += m + "+"
    end
  end
  def edit

  end
  def destroy
    @location.destroy!
    redirect_to location_index_path
  end

  def update
    if @location.update_attributes(location_params)
      redirect_to location_path
    else
      redirect_to edit_location_path(@location), alert: @location.errors.first
    end
  end
  def create
    @user = User.find(params[:location][:user].to_i)
    @location = @user.locations.create(location_params)
    if @user.save
      redirect_to location_path(@location)
    else
      redirect_to new_location_path, alert: @location.errors.first
    end
  end
  def new
    @location = Location.new
  end
  def location_params
    params.require(:location).permit(:title,:city,:address,:state,:country,:id)
  end
  def geo_json_api
    @locations = Location.all
    @geo_json = []
    @locations.each do |l|
      img_url = ""
      if l.photos.length > 0
        img_url = l.photos.mostViews.first.img_url.url
      end
      temp = { title: l.title , id: l.id, url: location_path(l), average_score: l.average_score, img_url: img_url , address: l.full_address,coordinates: [l.latitude,l.longitude]}
      @geo_json.push temp
    end
    render json: @geo_json
  end
  def set_location
    @location = Location.find(params[:id])
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
      if current_user.id != Location.find(params[:id]).user_id.to_i
        redirect_to location_index_path, alert: "You must own or be an admin to access this content."
      elsif !current_user.verified
        redirect_to "/user/disabled_account/#{current_user.id}", alert: "You must verify you email to perform this action."
      end
    else
      redirect_to location_index_path, alert: "You must be signed in to access this content."
    end
  end
end
