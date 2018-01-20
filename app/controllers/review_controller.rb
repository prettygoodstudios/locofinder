class ReviewController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'

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
end
