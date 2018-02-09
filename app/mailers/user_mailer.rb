class UserMailer < ApplicationMailer
  default from: 'miguel@prettygoodstudios.com'

  def verify_email(user)
    @user = User.find(user)
    mail(to: @user.email, subject: 'Locofinder Email Verification')
  end
  end
end
