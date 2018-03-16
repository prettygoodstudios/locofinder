class UserMailer < ApplicationMailer
  default from: 'info@geofoc.us'
  def verify_email(user)
    @user = User.find(user)
    @root_url = root_url
    mail(to: @user.email, subject: 'Geofocus Email Verification')
  end
  def new_report(report)
    @report = Report.find(report)
    @recipients = User.all.where(role: "admin")
    emails = @recipients.collect(&:email).join(",")
    @root_url = root_url
    mail(to: emails, subject: "Alert Additional Content Has Been Reported!")
  end
  def reset_password(user,token)
    @user = User.find(user)
    @token = token
    @root_url = root_url
    mail(to: @user.email, subject: "Reset Geofocus Password.")
  end
end
