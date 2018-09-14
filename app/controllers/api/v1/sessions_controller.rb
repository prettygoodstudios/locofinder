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
    @user = User.create(display: params[:display], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation], profile_img: params[:profile_img], offsetX: params[:offsetX], offsetY: params[:offsetY], zoom: params[:zoom])
    if @user.save
      @user.update_attribute("authentication_token",Devise.friendly_token)
      render json: @user.as_json(only: [:id, :email, :authentication_token, :display, :profile_img]), status: :created
    else
      render json: {errors: @user.errors}
    end
  end

  private

    def render_user user
      session = Session.create({user_id: user.id, authentication_token: Devise.friendly_token, created_at: DateTime.now})
      render json: { id: user.id, email: user.email, display: user.display, profile_img: user.profile_img, authentication_token: session.authentication_token}, status: :created
    end

    def user_params
      params.permit(:display, :email, :password, :password_confirmation, :session)
    end

end
