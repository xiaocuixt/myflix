class Todo < ActiveRecord::Base
	validates_presence_of :name

	def name_only?
	  description.blank?
	end
end
