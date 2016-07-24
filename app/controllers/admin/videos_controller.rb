class Admin::VideosController < ApplicationController
  before_filter :require_user
  before_filter :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have successfully add the video #{@video.title}."
      redirect_to new_admin_video_path
    else
      flash.now[:error] = "You cannot add this video, Please check errors."
      render :new
    end
  end

  private
  def require_admin
    if !current_user.admin?
      flash[:error] = "You are not authorized to do that."
      redirect_to home_path
    end
  end

  def video_params
    params.require(:video).permit(:title, :category_id, :small_cover, :large_cover,
                                  :description, :video_url)
  end
end