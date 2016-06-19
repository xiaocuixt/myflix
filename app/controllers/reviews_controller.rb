class ReviewsController < ApplicationController
  before_filter :require_user

  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.create(review_params.merge!(user: current_user))
    return redirect_to @video
    if review.save
      redirect_to @video
    else
      @reviews = @video.reviews
      render "videos/show"
    end
  end

  private
  def review_params
    params.require(:review).permit(:user_id, :video_id, :rating, :content)
  end
end