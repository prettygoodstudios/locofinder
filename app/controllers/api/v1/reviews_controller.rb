class Api::V1::ReviewsController < ApiController
  before_action :is_authencticated, only: [:update, :create]
  before_action :set_review, only: [:update]
  before_action :is_mine, only: [:update]

  def update
    if @review.update_attributes(review_params)
      render_reviews
    else
      render json: {errors: @review.errors}
    end
  end

  def create
    @review = Review.create(review_params)
    if @review.save
      render_reviews
    else
      render json: {errors: @review.errors}
    end
  end

  private

    def review_params
      {message: params[:message], score: params[:score], location_id: params[:location_id], user_id: @user.id}
    end

    def render_reviews
      reviews = Review.where("location_id = #{params[:location_id]}").order("id DESC")
      users = User.joins(:reviews).where("reviews.location_id = #{params[:location_id]}").order("reviews.id DESC")
      @reviews = reviews.zip(users).map do |r, u|
        { id: r.id, score: r.score, message: r.message ,user_id: r.user_id, user_display: u.display, user_profile: u.profile_img.url, user_zoom: u.zoom, user_width: u.width, user_height: u.height, user_offsetX: u.offsetX, user_offsetY: u.offsetY}
      end
      render json: @reviews
    end

    def set_review
      @review = Review.find(params[:id])
    end

    def is_mine
      if @user.id != @review.user_id
        head(:unauthorized)
      end
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
