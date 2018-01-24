class ReviewController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'
  before_action :is_logged_in, only: [:create]
  def create
    @location = Location.find(params[:review][:location].to_i)
    @user = User.find(params[:review][:user])
    @review = @location.reviews.build(review_params)
    @user.reviews << @review
    if @review.save
      redirect_to @location
    else
      redirect_to @location, alert: @review.errors.first
    end
  end
  def review_params
    params.require(:review).permit(:message,:score)
  end
  def is_logged_in
    if !signed_in?
      redirect_to location_index_path, alert: "You must be logged in to perform this action."
    end
  end
end
