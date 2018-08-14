class Api::V1::LocationsController < ApiController

  def index
    @locations = Location.all
    render json: @locations
  end

  def show
    @location = Location.find(params[:id])
    render json:  { location: @location, photos: @location.photos }
  end


  private
end
