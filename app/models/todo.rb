class Todo < ActiveRecord::Base

  has_many :taggings, :foreign_key => :todo_id
  has_many :tags, :through => :taggings

  validates_presence_of :name

	def name_only?
	  description.blank?
	end

  def display_text
    name + tag_text
  end

  private
  def tag_text
    if tags.any?
      " (#{tags.one? ? 'tag' : 'tags'}: #{tags.map(&:name).first(4).join(", ")}#{', more...' if tags.count > 4})"
    else
      ""
    end
  end
end
