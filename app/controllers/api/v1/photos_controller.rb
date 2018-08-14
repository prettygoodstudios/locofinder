class Api::V1::PhotosController < ApiController

  def show
    @photo = Photo.find(params[:id])
    render json: @photo
  end

  private

end
