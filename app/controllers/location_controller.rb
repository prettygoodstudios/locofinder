class LocationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  before_action :set_location, only: [:show,:edit,:update,:destroy]
  before_action :send_initial_email_verification_email, only: [:index,:show,:edit,:destroy,:update,:new]
  before_action :is_mine_or_admin, only: [:edit,:update,:destroy]
  before_action :is_logged_in, only: [:new,:create]
  before_action :send_to_landing, only: [:index]
  def index
    @locations = Location.all
  end
  def show
    reviews = Review.find_by_sql("SELECT r.*  FROM reviews r JOIN users u ON r.user_id = u.id WHERE r.location_id=#{@location.id} ORDER BY r.id DESC")
    users = User.find_by_sql("SELECT u.*  FROM users u JOIN reviews r ON r.user_id = u.id WHERE r.location_id=#{@location.id} ORDER BY r.id DESC")
    @reviews = reviews.zip(users)
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
  def my_location_api
    location = JSON.parse(open("http://ip-api.com/json").read)
    @my_location = { latitude: location["lat"], longitude: location["lon"]}
    render json: @my_location
  end
  def geo_json_api
    @locations = Location.all
    @geo_json = []
    @locations.each do |l|
      img_url = ""
      offSetX = nil
      offSetY = nil
      zoom = nil
      width = nil
      height = nil
      if l.photos.length > 0
        photo = l.photos.mostViews.first
        img_url = photo.img_url.url
        offsetX = photo.offsetX
        offsetY = photo.offsetY
        zoom = photo.zoom
        width = photo.width
        height = photo.height
      end
      temp = { title: l.title , id: l.id, url: location_path(l), average_score: l.average_score, img_url: img_url , address: l.full_address, coordinates: [l.latitude,l.longitude], slug: l.slug, offsetX: offsetX, offsetY: offsetY, zoom: zoom, width: width, height: height}
      @geo_json.push temp
    end
    render json: @geo_json
  end
  def set_location
    @location = Location.where("slug = '#{params[:id]}'").first
  end
  def send_initial_email_verification_email
    if signed_in?
      if current_user.token == nil
        @user = User.find(current_user.id)
        @user.update_attribute("width",@user.profile_img.width)
        @user.update_attribute("height",@user.profile_img.height)
        @user.update_attribute("token",rand(36**16).to_s(36))
        @user = @user.id
        UserMailer.verify_email(@user).deliver!
        redirect_to location_index_path, alert: "Check your email for an email that will verify your email address and enable your accounts."
      end
    end
  end
  def is_logged_in
    if !signed_in?
      redirect_to location_index_path, alert: "You must be logged in to perform this action."
    elsif !current_user.verified
      redirect_to "/user/disabled_account/#{current_user.id}", alert: "You must verify your email to perform this action."
    end
  end
  def is_mine_or_admin
    if signed_in?
      if @location.user_id.to_i != current_user.id.to_i and current_user.role != "admin"
        redirect_to location_index_path, alert: "You must own or be an admin to access this content."
      elsif !current_user.verified
        redirect_to "/user/disabled_account/#{current_user.id}", alert: "You must verify you email to perform this action."
      end
    else
      redirect_to location_index_path, alert: "You must be signed in to access this content."
    end
  end
  def send_to_landing
    if !signed_in? and params[:see] != "true"
      redirect_to "/landing"
    end
  end
end
