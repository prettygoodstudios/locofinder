class ReportController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  before_action :remove_old_reports, only: [:index,:show]
  before_action :is_admin, only: [:index,:show,:destroy]
  before_action :is_logged_in, only: [:new,:create]
  before_action :set_report, only: [:show,:destroy,:report_destroy]
  def index
    @reports = Report.all
  end
  def show
    @report = Report.find(params[:id])
  end
  def new
    @report = Report.new
    @review = params[:review]
    @location = params[:location]
    @photo = params[:photo]
  end
  def googleb644d22d0a6d8ad2
    render :layout => false
  end
  def create
    @report = Report.create(report_params)
    if @report.save
      UserMailer.new_report(@report.id,current_user.id).deliver!
      redirect_to location_index_path, alert: "Successfully reported content."
    else
      redirect_to new_report_path, alert: @report.errors.first
    end
  end
  def destroy
    @report.destroy!
    redirect_to report_index_path, alert: "Report Resolved."
  end
  def report_destroy
    if @report.what_type == "review"
      Review.find(@report.review_id).destroy!
    elsif @report.what_type == "location"
      Location.find(@report.location_id).destroy!
    elsif @report.what_type == "photo"
      Photo.find(@report.photo_id).destroy!
    end
    @report.destroy!
    redirect_to report_index_path, alert: "Deleted item and resolved report."
  end
  def report_params
    params.require(:report).permit(:message,:user_id,:location_id,:review_id)
  end
  def set_report
    @report = Report.find(params[:id])
  end
  def is_logged_in
    if signed_in?
      if !current_user.verified
        redirect_to location_index_path, alert: "You must verify your account to report content."
      end
    else
      redirect_to location_index_path, alert: "You must be signed in to report content."
    end
  end
  def is_admin
    if signed_in?
      if current_user.role != "admin"
        redirect_to location_index_path, alert: "You must be an admin to access this content."
      end
    else
      redirect_to location_index_path, alert: "You must be an admin to access this content."
    end
  end
  def remove_old_reports
    Report.all.each do |r|
      if r.what_type == "location"
        r.destroy if Location.where("id=#{r.location_id}").length == 0
      elsif r.what_type == "review"
        r.destroy if Review.where("id=#{r.review_id}").length == 0
      elsif r.what_type == "photo"
        r.destroy if Photo.where("id=#{r.photo_id}").length == 0
      end
    end
  end
end
