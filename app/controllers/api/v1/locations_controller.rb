class Api::V1::LocationsController < ApiController
  before_action :is_authencticated, only: [:create, :update]
  before_action :set_location, only: [:show, :update]
  before_action :is_mine, only: [:update]

  def index
    @locations = Location.all
    render json: @locations
  end

  def show
    ph = @location.photos.mostViews
    users = User.joins(:photos).where("photos.location_id = #{@location.id}").order("photos.views DESC")
    @photos = ph.zip(users).map do |p, u|
      { id: p.id, zoom: p.zoom, offsetX: p.offsetX, offsetY: p.offsetY, width: p.width, height: p.height, caption: p.caption, user_id: p.user_id, img_url: p.img_url.url, views: p.views, user_display: u.display, user_profile: u.profile_img.url, user_zoom: u.zoom, user_width: u.width, user_height: u.height, user_offsetX: u.offsetX, user_offsetY: u.offsetY}
    end
    render json:  { location: @location, photos: @photos }
  end

  def create
    @location = @user.locations.create(location_params)
    if @location.save
      ph = @location.photos.mostViews
      users = User.joins(:photos).where("photos.location_id = #{@location.id}").order("photos.views DESC")
      @photos = ph.zip(users).map do |p, u|
        { id: p.id, zoom: p.zoom, offsetX: p.offsetX, offsetY: p.offsetY, width: p.width, height: p.height, caption: p.caption, user_id: p.user_id, img_url: p.img_url.url, views: p.views, user_display: u.display, user_profile: u.profile_img.url, user_zoom: u.zoom, user_width: u.width, user_height: u.height, user_offsetX: u.offsetX, user_offsetY: u.offsetY}
      end
      render json:  { location: @location, photos: @photos }
    else
      render json: { errors: @location.errors }
    end
  end

  def update
    if @location.update_attributes(location_params)
      render json: @location
    else
      render json: @location.errors
    end
  end

  private

    def location_params
      params.permit(:title,:city,:address,:state,:country,:id)
    end

    def is_authencticated
      @user = nil
      if !User.authenticate_via_token(params[:email], params[:token])
        head(:unauthorized)
      else
        @user = User.where("email = '#{params[:email]}'").first
      end
    end

    def is_mine
      if @user.id.to_i != @location.user_id.to_i
        head(:unauthorized)
      end
    end

    def set_location
      @location = Location.find(params[:id])
    end
end
