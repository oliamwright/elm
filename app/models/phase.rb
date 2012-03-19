class Phase < ActiveRecord::Base

	include PhaseCan
	include PhasePermissions

  belongs_to :project
	has_many :sprints

	def short_name
		"P#{self.number}"
	end

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

	def sort_number
		t = 0
		self.display_number.split(/\./).each_with_index do |p, idx|
			t += p.to_i * (1000 ** (3 - idx))
		end
		t
	end
end
