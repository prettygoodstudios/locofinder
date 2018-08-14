class Api::V1::LocationsController < ApiController
  before_action :is_authencticated, only: [:create, :update]
  before_action :set_location, only: [:show, :update]
  before_action :is_mine, only: [:update]

  def index
    @locations = Location.all
    render json: @locations
  end

  def show
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
