class UserMailer < ApplicationMailer
  default from: 'miguel@prettygoodstudios.com'

  def verify_email(user)
    @user = User.find(user)
    mail(to: @user.email, subject: 'Geofocus Email Verification')
  end
  def new_report(report)
    @report = Report.find(report)
    @recipients = User.all.where(role: "admin")
    emails = @recipients.collect(&:email).join(",")
    mail(to: emails, subject: "Alert Additional Content Has Been Reported!")
  end
  def reset_password(user,token)
    @user = User.find(user)
    @token = token
    mail(to: @user.email, subject: "Reset Geofocus Password.")
  end
end
