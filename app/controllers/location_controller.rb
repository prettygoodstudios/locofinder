class LocationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  def index
    @locations = Location.all
  end
  def show
    @location = Location.find(params[:id])
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
      temp = { title: l.title , id: l.id, url: location_path(l), edit: edit_location_path(l), average_score: l.average_score, address: l.full_address,coordinates: [l.latitude,l.longitude]}
      @geo_json.push temp
    end
    render json: @geo_json
  end
end
