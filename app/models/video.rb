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

  def average_rating
    reviews.average(:rating).to_f.round(1) if reviews.any?
  end

  def as_indexed_json(options={})
    as_json(
      methods: [:average_rating],
      only: [:title, :description],
      include: {
        reviews: {only: [:content]}
      }
    )
  end

  class << self
    def search(query, options={})
      search_def = {
        query: {
          multi_match: {
            query: query,
            fields: ["title^100", "description^50"],  #100和50表示权重
            operator: "and"
          }
        }
      }
      if query.present? && options[:reviews].present?
        search_def[:query][:multi_match][:fields] << "reviews.content"
      end

      if options[:rating_from].present? || options[:rating_to].present?
        search_def[:query] = {
          range: {
            average_rating: {
              gte: (options[:rating_from] if options[:rating_from].present?),
              lte: (options[:rating_to] if options[:rating_to].present?)
            }
          }
        }
      end
      __elasticsearch__.search(search_def)
    end
  end
end
