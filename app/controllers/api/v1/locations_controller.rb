class Api::V1::LocationsController < ApiController
  before_action :is_authencticated, only: [:create]

  def index
    @locations = Location.all
    render json: @locations
  end

  def show
    @location = Location.find(params[:id])
    render json:  { location: @location, photos: @location.photos }
  end

  def create
    @location = @user.locations.create(location_params)
    if @location.save
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
end
