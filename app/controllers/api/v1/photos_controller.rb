class Api::V1::PhotosController < ApiController
  before_action :is_authencticated

  def show
    @photo = Photo.find(params[:id])
    render json: @photo
  end

  def create
    @location = Location.find(params[:location].to_i)
    @photo = @location.photos.build(photo_params)
    @user.photos << @photo
    if @photo.save
      @photo.update_attribute("views",0)
      @photo.update_attribute("width",@photo.img_url.width)
      @photo.update_attribute("height",@photo.img_url.height)
      render json: @photo
    else
      render json: { errors: ["Could not save photo."]}
    end
  end

  private

    def photo_params
      params.permit(:img_url,:caption,:width,:height,:zoom,:offsetX,:offsetY)
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
