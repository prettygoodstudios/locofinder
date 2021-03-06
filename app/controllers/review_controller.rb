class ReviewController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  before_action :set_review, only: [:update,:destroy,:edit]
  before_action :is_logged_in, only: [:create]
  before_action :is_mine_or_admin, only: [:destroy,:edit,:update]
  def create
    @location = Location.find(params[:review][:location].to_i)
    @user = User.find(params[:review][:user])
    @review = @location.reviews.build(review_params)
    @user.reviews << @review
    if @review.save
      redirect_to @location, alert: "Successfully Posted Review!"
    else
      redirect_to @location, alert: @review.errors.first
    end
  end
  def edit

  end
  def update
    @location = Location.find(@review.location_id)
    if @review.update_attributes(review_params)
      redirect_to @location, alert: "Successfully Updated Review!"
    else
      redirect_to edit_review_path(@review), alert: @review.errors.first
    end
  end
  def destroy
    @location = Location.find(@review.location_id)
    @review.destroy!
    redirect_to @location, alert: "You have just deleted a review"
  end
  def review_params
    params.require(:review).permit(:message,:score)
  end
  def is_logged_in
    if !signed_in?
      redirect_to location_index_path, alert: "You must be logged in to perform this action."
    elsif !current_user.verified
      redirect_to "/user/disabled_account/#{current_user.id}", alert: "You must verify you email to perform this action."
    end
  end
  def set_review
    @review = Review.find(params[:id])
  end
  def is_mine_or_admin
    if signed_in?
      if current_user.id != Review.find(params[:id]).user_id and current_user.role != "admin"
        redirect_to location_index_path, alert: "You must own or be an admin to access this content."
      elsif !current_user.verified and current_user.role != "admin"
        redirect_to "/user/disabled_account/#{current_user.id}", alert: "You must verify you email to perform this action."
      end
    else
      redirect_to location_index_path, alert: "You must be signed in to access this content."
    end
  end
end
