class Api::V1::LocationsController < ApiController
  before_action :is_authencticated, only: [:create, :update]
  before_action :set_location, only: [:show, :update]
  before_action :is_mine, only: [:update]

  def index
    @locations = Location.all
    render json: @locations
  end

  def show
    return_location_show @location
  end

  def create
    @location = @user.locations.create(location_params)
    if @location.save
      return_location_show @location
    else
      render json: { errors: @location.errors }
    end
  end

  def update
    if @location.update_attributes(location_params)
      return_location_show @location
    else
      render json: { errors: @location.errors }
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

    def return_location_show location
      ph = location.photos.mostViews
      users = User.joins(:photos).where("photos.location_id = #{location.id}").order("photos.views DESC")
      photos = ph.zip(users).map do |p, u|
        { id: p.id, zoom: p.zoom, offsetX: p.offsetX, offsetY: p.offsetY, width: p.width, height: p.height, caption: p.caption, user_id: p.user_id, img_url: p.img_url.url, views: p.views, user_display: u.display, user_profile: u.profile_img.url, user_zoom: u.zoom, user_width: u.width, user_height: u.height, user_offsetX: u.offsetX, user_offsetY: u.offsetY}
      end
      rv_users = User.find_by_sql("SELECT u.* FROM users u JOIN reviews r ON r.user_id = u.id WHERE r.location_id = #{location.id} ORDER BY r.score DESC")
      rv = Review.find_by_sql("SELECT r.* FROM reviews r JOIN users u ON r.user_id = u.id WHERE r.location_id = #{location.id} ORDER BY r.score DESC")
      reviews = rv.zip(rv_users).map do |r, u|
        { id: r.id, score: r.score, message: r.message ,user_id: r.user_id, user_display: u.display, user_profile: u.profile_img.url, user_zoom: u.zoom, user_width: u.width, user_height: u.height, user_offsetX: u.offsetX, user_offsetY: u.offsetY}
      end
      render json:  { location: location, photos: photos, reviews: reviews }
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
