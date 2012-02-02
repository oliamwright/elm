class Sprint < ActiveRecord::Base

	include SprintCan
	include SprintPermissions

  belongs_to :project
	has_many :stories

	def running_late?
		return false if self.complete?
		self.percentage_time_passed > self.percent_complete
	end

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

	def renumber_if_necessary!
		nec = false
		c = 1
		self.stories.order("number asc").each do |s|
			nec = true unless s.number == c
			c += 1
		end
		if nec
			self.renumber!
		end
	end

	def days_in_sprint
		((self.end_date - self.start_date) / 60.0 / 60.0 / 24.0).to_i
	end

	def days_since_start
		(Date.today - self.start_date.to_date).to_i
	end

	def percentage_time_passed
		[self.days_since_start / self.days_in_sprint * 100, 0].max
	end

	def display_number
		"#{self.number}"
	end

	def time_complete
		self.stories.select { |s| s.complete? }.inject(0) { |s,v| s += v.estimated_time }
	end

	def time
		self.stories.select { |s| !s.ignored? }.inject(0) { |s,v| s += v.estimated_time }
	end

	def complete?
		return true if self.percent_complete >= 1
		return false if self.stories.empty?
		return true if (self.stories.map { |s| s.status } - ["dev", "stage", "completed", "ignored", "prod", "tested"]).empty?
		false
	end

	def display_duration
		self.project.sprint_duration / 1.week
	end

	def start_date
		self.project.start_date + ((self.number - 1) * self.project.sprint_duration).seconds rescue Date.new(1975,1,13)
	end

	def end_date
		self.start_date + self.project.sprint_duration.seconds
	end

	def percent_complete
		return 0 unless self.time > 0
		self.time_complete / self.time rescue 0.0
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
