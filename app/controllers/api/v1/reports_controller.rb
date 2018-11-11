class Api::V1::ReportsController < ApiController
  before_action :is_authencticated, only: [:create]
  
  def create
    @report = Report.create(report_params)
    if @report.save
      UserMailer.new_report(@report.id,@user.id).deliver!
      render json: { report: @report }
    else
      render json: { errors: @report.errors }
    end
  end

  private

    def report_params
      params.permit(:message,:user_id,:location_id,:review_id)
    end

    def is_authencticated
      @user = nil
      if !User.authenticate_via_token(params[:email], params[:token])
        head(:unauthorized)
      else
        @user = User.where("email = '#{params[:email]}'").first
      end
    end

end
