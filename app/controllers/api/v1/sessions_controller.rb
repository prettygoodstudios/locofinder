class Api::V1::SessionsController < ApiController

  def create
    user = User.where("email = '#{params[:email]}'").first
    if user&.valid_password?(params[:password])
      user.update_attribute("authentication_token",Devise.friendly_token)
      render json: user.as_json(only: [:id, :email, :authentication_token, :display, :profile_img]), status: :created
    else
      head(:unauthorized)
    end
  end

  def authenticate
    if User.authenticate_via_token params[:email], params[:token]
      user = User.where("email = '#{params[:email]}'").first
      user.update_attribute("authentication_token",Devise.friendly_token)
      render json: user.as_json(only: [:id, :email, :authentication_token, :display, :profile_img]), status: :created
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
    @user = User.create(display: params[:display], email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
    if @user.save
      @user.update_attribute("authentication_token",Devise.friendly_token)
      render json: @user
    else
      render json: {errors: @user.errors}
    end
  end

  private

    def user_params
      params.permit(:display, :email, :password, :password_confirmation, :session)
    end

end
