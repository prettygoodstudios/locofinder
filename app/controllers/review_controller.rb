class ReviewController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  before_action :is_logged_in, only: [:create]
  before_action :is_mine_or_admin, only: [:destroy]
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
  def destroy
    @review = Review.find(params[:id])
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
    end
  end
  def is_mine_or_admin
    if signed_in?
      if current_user.id != Review.find(params[:id]).user_id
        redirect_to location_index_path, alert: "You must own or be an admin to access this content."
      end
    else
      redirect_to location_index_path, alert: "You must be signed in to access this content."
    end
  end
end
