class UserController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  before_action :set_user, only: [:show,:enable_account,:send_email_verification,:reset_password,:new_password,:update_profile_photo,:edit_profile_image]
  before_action :is_mine_or_admin, only: [:edit_profile_image, :update_profile_image]
  def index
    @users = User.all.index_sort
  end
  def show
    @photos = @user.photos
  end
  def create
    @user = User.find(current_user.id)
    @user.update_attribute("width",@user.profile_img.width)
    @user.update_attribute("height",@user.profile_img.height)
    UserMailer.verify_email(current_user.id).deliver!
  end
  def edit_profile_image

  end
  def update_profile_image
    @user = User.find(params[:user][:id])
    if @user.update_attributes(params.require(:user).permit(:profile_img,:width,:height,:zoom,:offsetX,:offsetY,:id))
      @user.update_attribute("width",@user.profile_img.width)
      @user.update_attribute("height",@user.profile_img.height)
      redirect_to "/user/show/#{@user.id}", alert: "Successfully updated profile picture."
    else
      redirect_to "/user/edit_profile/#{@user.id}", alert: @user.errors.first
    end
  end
  def landing

  end
  def enable_account
    if @user.token == params[:token]
      @user.update_attribute("verified",true)
    elsif !@user.verified
      redirect_to "", alert: "Incorrect token email verification failed."
    else
      redirect_to location_index_path, alert: "You have already verified your email."
    end
    redirect_to location_index_path, alert: "Your account has been verified."
  end
  def disabled_account
  end
  def send_email_verification
    @user.update_attribute("token",rand(36**16).to_s(36))
    @user = @user.id
    UserMailer.verify_email(@user).deliver!
    redirect_to location_index_path, alert: "Sent email verification."
  end
  def reset_password
    token = rand(36**16).to_s(36)
    @user.update_attribute("password",token)
    UserMailer.reset_password(@user,token)
  end
  def new_password
    if sign_in(@user,password: token, email: @user.email)

    else
      redirect_to location_index_path, alert: "You dont have permission to perform this action."
    end
  end
  def set_user
    @user = User.find(params[:id])
  end
  def is_mine_or_admin
    if signed_in?
      if current_user.id != params[:id].to_i and current_user.role != "admin"
        if params[:user] != nil
          if current_user.id != params[:user][:id].to_i
            redirect_to location_index_path, alert: "You must own or be an admin to access this content."
          end
        else
          redirect_to location_index_path, alert: "You must own or be an admin to access this content."
        end
      end
    else
      redirect_to location_index_path, alert: "You must be signed in to access this content."
    end
  end
end
