class Api::V1::SessionsController < ApiController

  def create
    user = User.where("email = '#{params[:email]}'").first
    if user&.valid_password?(params[:password])
      render_user user
    else
      head(:unauthorized)
    end
  end

  def authenticate
    if User.authenticate_via_token params[:email], params[:token]
      user = User.where("email = '#{params[:email]}'").first
      render_user user
    else
      head(:unauthorized)
    end
  end

  def destroy
    user = User.where("email = '#{params[:email]}'").first
    if user.authentication_token == params[:token]
      user.update_attribute("authentication_token",Devise.friendly_token)
      render json: user.as_json(only: [:id, :email, :authentication_token]), status: :created
    else
      head(:unauthorized)
    end
  end

  def create_user
    @user = User.create(display: params[:display], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation], profile_img: params[:profile_img], offsetX: params[:offsetX], offsetY: params[:offsetY], zoom: params[:zoom], bio: params[:bio])
    if @user.save
      @user.update_attribute("authentication_token",Devise.friendly_token)
      @user.update_attribute("width",@user.profile_img.width)
      @user.update_attribute("height",@user.profile_img.height)
      render_user @user
    else
      render json: {errors: @user.errors}
    end
  end

  def edit_user
    @user = User.find(params[:id])
    if @user&.valid_password?(params[:current_password])
      set_password = params[:password] != "" ? params[:password] : params[:current_password]
      profile_img = params[:profile_img] ? params[:profile_img] : @user.profile_img
      zoom = params[:zoom] ? params[:zoom] : @user.zoom
      offsetX = params[:offsetX] ? params[:offsetX] : @user.offsetX
      offsetY = params[:offsetY] ? params[:offsetY] : @user.offsetY
      if @user.update_attributes({display: params[:display], bio: params[:bio], email: params[:email], password: set_password, profile_img: profile_img})
        @user.update_attribute("width",@user.profile_img.width)
        @user.update_attribute("height",@user.profile_img.height)
        @user.update_attribute("offsetX", offsetX)
        @user.update_attribute("offsetY", offsetY)
        @user.update_attribute("zoom", zoom)
        render_user @user
      else
        render json: {errors: @user.errors}
      end
    else
      render json: {errors: ["Incorrect current password."]}
    end
  end

  private

    def render_user user
      session = Session.create({user_id: user.id, authentication_token: Devise.friendly_token, created_at: DateTime.now})
      render json: { id: user.id, email: user.email, display: user.display, bio: user.bio, profile_img: user.profile_img, authentication_token: session.authentication_token}, status: :created
    end

    def user_params
      params.permit(:display, :email, :password, :password_confirmation, :session, :bio)
    end

end
