class Sprint < ActiveRecord::Base

	include SprintCan
	include SprintPermissions

  belongs_to :project
	has_many :stories

	def renumber!
		if self.stories.empty? && self.end_date > self.project.end_date
			self.destroy
			return
		end
		c = 1
		self.stories.order("number asc").each do |s|
			s.number = c
			s.save
			c += 1
		end
	end

	def display_number
		"#{self.number}"
	end

	def complete?
		self.percent_complete >= 1
	end

	def display_duration
		self.project.sprint_duration / 1.week
	end

	def start_date
		self.project.start_date + ((self.number - 1) * self.project.sprint_duration).seconds
	end

	def end_date
		self.start_date + self.project.sprint_duration.seconds
	end

	def percent_complete
		return 0 if self.stories.count.to_f == 0.0
		self.stories.select { |s| s.complete? }.count.to_f / self.stories.count.to_f rescue 0
	end

	def display_percent_complete
		"#{(self.percent_complete * 100).to_i} %"
	end

	def last_story_number
		self.stories.order("number asc").last.number rescue 0
	end

	def next_sprint
		ns = Sprint.where("project_id = ? and number > ?", self.project_id, self.number).order("number asc").first
#		if ns.nil?
#			ns = Sprint.new
#			ns.project = self.project
#			ns.number = self.number + 1
#			ns.save
#		end
		ns
	end

	def force_next_sprint!
		ns = Sprint.where("project_id = ? and number > ?", self.project_id, self.number).order("number asc").first
		if ns.nil?
			ns = Sprint.new
			ns.project = self.project
			ns.number = self.number + 1
			ns.save
		end
		ns
	end

	def previous_sprint
		ps = Sprint.where("project_id = ? and number < ?", self.project_id, self.number).order("number desc").first
	end

	def deletable?
		self.number > (self.project.duration / (self.project.sprint_duration / 1.week))
	end
end
