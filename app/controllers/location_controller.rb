class LocationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  def index
    @locations = Location.all
  end
  def show
    @location = Location.find(params[:id])
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

    end
  end
  def create
    @location = Location.create!(location_params)
    if @location.save
      redirect_to location_path(@location)
    else

    end
  end
  def new
    @location = Location.new
  end
  def location_params
    params.require(:location).permit(:title,:city,:address,:state,:country)
  end
  def geo_json_api
    @locations = Location.all
    @geo_json = []
    @locations.each do |l|
      geo = { type: "Point", coordinates: [l.latitude,l.longitude]}
      props = { name: l.id.to_s, color: "blue", rank: "7", ascii: "71", letter: "G" }
      temp = { type: "Feature", geometry: geo, properties: props  }
      @geo_json.push temp
    end
    stringVer = JSON.generate(@geo_json).to_s
    puts stringVer
    stringVer.sub!("[","{")
    stringVer = stringVer.reverse.sub("]","}").reverse
    render json: { "type": "FeatureCollection", "features": @geo_json }
  end
end
