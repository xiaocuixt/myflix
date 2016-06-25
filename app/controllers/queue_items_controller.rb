class QueueItemsController < ApplicationController
  before_filter :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.queue_items.include?(queue_item)
    normalize_queue_item_positions
    redirect_to my_queue_path
  end

  def update_queue
    begin
      ActiveRecord::Base.transaction do
        update_queue_items
        normalize_queue_item_positions
      end
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "invalid positon numbers."
    end
    redirect_to my_queue_path
  end

  private
  def update_queue_items
    params[:queue_items].each do |queue_item_data|
      queueitem = QueueItem.find(queue_item_data["id"])
      queueitem.update!(position: queue_item_data["position"])
    end
  end

  def normalize_queue_item_positions
    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update!(position: index + 1)
    end
  end

  def queue_video video
    QueueItem.create(video: video, user: current_user, position: new_queue_item_position) unless current_user_queued_video? video
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def current_user_queued_video? video
    current_user.queue_items.map(&:video).include? video
  end
end