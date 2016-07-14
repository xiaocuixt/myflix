class User < ActiveRecord::Base
  include Tokenable
  has_many :reviews, -> {order("created_at DESC")}
  has_many :queue_items, -> {order(:position)}
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id

  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_secure_password validations: false

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update!(position: index + 1)
    end
  end

  def queued_video? video
    #queue_items.where(video_id: video.id).first.present?
    queue_items.map(&:video).include?(video)
  end

  def follow?(anthor_user)
    following_relationships.map(&:leader).include?(anthor_user)
  end

  def follow(anthor_user)
    following_relationships.create(leader: anthor_user) if can_follow?(anthor_user)
  end

  def can_follow?(anthor_user)
    !follow?(anthor_user) && self != anthor_user
  end
end