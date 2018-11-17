class UserMailer < ApplicationMailer
  default from: 'info@geofoc.us'
  def verify_email(user)
    @user = User.find(user)
    @token = @user.token
    @root_url = "https://geofoc.us/"
    mail(to: @user.email, subject: 'Geofocus Email Verification')
  end
  def new_report(report,user)
    @report = Report.find(report)
    @user = User.find(user)
    @recipients = User.all.where(role: "admin")
    emails = @recipients.collect(&:email).join(",")
    @root_url = "https://geofoc.us/"
    mail(to: emails, subject: "Alert Additional Content Has Been Reported!")
  end
  def reset_password(user,token)
    @user = User.find(user)
    @token = token
    @root_url = "https://geofoc.us/"
    mail(to: @user.email, subject: "Reset Geofocus Password.")
  end
end
