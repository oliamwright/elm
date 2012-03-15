class Phase < ActiveRecord::Base

	include PhaseCan
	include PhasePermissions

  belongs_to :project
	has_many :sprints

	def display_number
		"#{self.number}"
	end

	def renumber!
		c = 1
		self.sprints.order("number asc").each do |s|
			s.number = c
			s.save
			c += 1
		end
	end

	def display_name
		!self.name.blank? ? self.name.titleize : "Phase #{self.number}"
	end

end
