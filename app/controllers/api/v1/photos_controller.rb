class Api::V1::PhotosController < ApiController
  before_action :is_authencticated, only: [:create]

  def show
    @photo = Photo.find(params[:id])
    @user = User.find(@photo.user_id)
    @location = Location.find(@photo.location_id)
    render json: {
      photo: @photo,
      user: {
        email: @user.email,
        display: @user.display,
        profile_img: @user.profile_img,
        user_zoom: @user.zoom,
        user_width: @user.width,
        user_height: @user.height,
        user_offsetX: @user.offsetX,
        user_offsetY: @user.offsetY
      },
      location: {
        title: @location.title
      }
    }
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
