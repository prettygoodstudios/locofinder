class Api::V1::UsersController < ApiController

  def index
    render json: User.index_sort
  end

  def show
    @user = User.find(params[:id])
    @user.authentication_token = ""
    render json: { user: @user, photos: @user.photos.mostViews }
  end

  def reset_password
    @user = User.where("email='#{params[:email]}'").first
    if @user
      token = rand(36**16).to_s(36)
      @user.update_attribute("password",token)
      UserMailer.reset_password(@user.id,token).deliver!
      render json: {message: "Sent email containing instructions to reset password."}
    else
      render json: {errors: ["Could not find email address."]}
    end
  end

  private

end
