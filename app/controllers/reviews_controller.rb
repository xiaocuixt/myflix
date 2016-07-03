class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    review = @video.reviews.build(review_params)

    if review.save
      flash[:success] = "Thank you for your review."
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end

  private
  def review_params
    params.require(:review).permit(:content, :rating).merge!(user: current_user)
  end
end