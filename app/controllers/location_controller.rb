class LocationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  def index
    @locations = Location.all
  end
  def show
    @location = Location.find(params[:id])
  end
  def edit
    @location = Location.find(params[:id])
  end
  def destroy
    @location = Location.find(params[:id])
    @location.destroy!
    redirect_to location_index_path
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(location_params)
      redirect_to location_path
    else

    end
  end
  def create
    @location = Location.create!(location_params)
    if @location.save
      redirect_to location_path
    else

    end
  end
  def new
    @location = Location.new
  end
  def location_params
    params.require(:location).permit(:title,:city,:address,:state,:country)
  end
end
