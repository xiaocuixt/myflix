class Todo < ActiveRecord::Base

	def name_only?
	  description.blank?
	end
end
