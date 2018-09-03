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
      location = Location.find(params[:location_id])
      ph = location.photos.mostViews
      users = User.joins(:photos).where("photos.location_id = #{location.id}").order("photos.views DESC")
      photos = ph.zip(users).map do |p, u|
        { id: p.id, zoom: p.zoom, offsetX: p.offsetX, offsetY: p.offsetY, width: p.width, height: p.height, caption: p.caption, user_id: p.user_id, img_url: p.img_url.url, views: p.views, user_display: u.display, user_profile: u.profile_img.url, user_zoom: u.zoom, user_width: u.width, user_height: u.height, user_offsetX: u.offsetX, user_offsetY: u.offsetY}
      end
      rv_users = User.find_by_sql("SELECT u.* FROM users u JOIN reviews r ON r.user_id = u.id WHERE r.location_id = #{location.id} ORDER BY r.score DESC")
      rv = Review.find_by_sql("SELECT r.* FROM reviews r JOIN users u ON r.user_id = u.id WHERE r.location_id = #{location.id} ORDER BY r.score DESC")
      reviews = rv.zip(rv_users).map do |r, u|
        { id: r.id, score: r.score, message: r.message ,user_id: r.user_id, user_display: u.display, user_profile: u.profile_img.url, user_zoom: u.zoom, user_width: u.width, user_height: u.height, user_offsetX: u.offsetX, user_offsetY: u.offsetY}
      end
      render json:  { location: location, photos: photos, reviews: reviews }
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
