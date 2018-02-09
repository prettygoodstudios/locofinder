class UserController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'

  def show
    @user = User.find(params[:id])
    @photos = @user.photos
  end
  def create
    UserMailer.verify_email(current_user.id).deliver!
  end
  def enable_account
    @user = User.find(params[:id])
    if @user.token == params[:token]
      @user.update_attribute("verified",true)
    elsif !@user.verified
      redirect_to "", alert: "Incorrect token email verification failed."
    else
      redirect_to location_index_path, alert: "You have already verified your email."
    end
  end
  def send_email_verification
    @user = User.find(params[:id]).id
    UserMailer.verify_email(@user).deliver!
    redirect_to location_index_path, alert: "Sent email verification."
  end
  def disabled_account
  end
end
