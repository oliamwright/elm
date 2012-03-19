class Sprint < ActiveRecord::Base

	include SprintCan
	include SprintPermissions

  belongs_to :project
	belongs_to :phase
	has_many :stories
	has_many :additional_time_items

	def full_name
		"#{self.phase.short_name} : #{self.display_name}"
	end

	def display_name
		"S#{self.number}"
	end

	def team_resourced
		self.stories.collect { |s| s.task_ownerships }.flatten.map { |to| to.user }.uniq.count
	end

	def team
		self.stories.collect { |s| s.task_ownerships }.flatten.map { |to| to.user }.uniq
	end

	def running_late?
		return false if self.complete?
		self.percentage_time_passed > self.percent_complete rescue false
	end

	def renumber!
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
		(self.end_date.to_date - self.start_date.to_date).to_i
	end

	def days_since_start
		(Date.today - self.start_date.to_date).to_i
	end

	def percentage_time_passed
		[self.days_since_start / self.days_in_sprint * 100, 0].max
	end

	def display_number
		"#{self.phase.display_number}.#{self.number}"
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

	def old_start_date
		self.project.start_date + ((self.number - 1) * self.project.sprint_duration).seconds rescue Date.new(1975,1,13)
	end

#	def start_date
#		self.project.start_date + ((self.number - 1) * self.project.sprint_duration).seconds rescue Date.new(1975,1,13)
#	end

	def end_date
		self.start_date + self.project.sprint_duration.seconds rescue Date.today
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
		ns = Sprint.where("project_id = ? and phase_id = ? and number > ?", self.project_id, self.phase_id, self.number).order("number asc").first
		if ns.nil?
			p = Phase.where("project_id = ? and id > ?", self.project_id, self.phase_id).order('number asc').first
			ns = p.sprints.first rescue nil
		end
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
		logger.debug("fetching previous sprint for [phase #{self.phase.number} / sprint #{self.number}]")
		ps = Sprint.where("project_id = ? and phase_id = ? and number < ?", self.project_id, self.phase_id, self.number).order("number desc").first
		if ps.nil?
			logger.debug("no previous sprint; fetching previous phase")
			p = Phase.where("project_id = ? and id < ?", self.project_id, self.phase_id).order('number desc').first
			unless p.nil?
				ps = p.sprints.last
				unless ps.nil?
					logger.debug("found [phase #{ps.phase.number} / sprint #{ps.number}]")
				else
					logger.debug("no sprints in previous phase")
				end
			else
				logger.debug("no previous phase")
			end
		else
			logger.debug("found [phase #{self.phase.number} / sprint #{ps.number}]")
		end
		ps
	end

	def deletable?
		self.number > (self.project.duration / (self.project.sprint_duration / 1.week))
	end

	def sort_number
		t = 0
		self.display_number.split(/\./).each_with_index do |p, idx|
			t += p.to_i * (1000 ** (3 - idx))
		end
		t
	end
end
