class Api::V1::UsersController < ApiController

  def index
    render json: User.index_sort
  end

  def show
    @user = User.find(params[:id])
    render json: { user: @user, photos: @user.photos.mostViews }
  end

  private

end
