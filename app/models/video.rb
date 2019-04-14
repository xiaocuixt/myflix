class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ["myflix", Rails.env].join('_')

	belongs_to :category
  has_many :reviews, -> {order('created_at DESC')}
  has_many :queue_items

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

	validates_presence_of :title, :description


	def self.search_by_title search_term
		return [] if search_term.blank?
		where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
	end

  def as_indexed_json(options={})
    as_json(only: [:title])
  end
end
