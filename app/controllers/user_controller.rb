class UserController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  before_action :set_user, only: [:show,:enable_account,:send_email_verification]
  def show
    @photos = @user.photos
  end
  def create
    UserMailer.verify_email(current_user.id).deliver!
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
  def set_user
    @user = User.find(params[:id])
  end
end
