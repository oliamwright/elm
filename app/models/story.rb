class Story < ActiveRecord::Base

	include StoryCan
	include StoryPermissions

	belongs_to :owner, :class_name => 'User'
	belongs_to :project
	belongs_to :sprint
	has_many :sub_items

	scope :backlog, where("sprint_id is null")
	scope :for_sprint, lambda { |sid| where("sprint_id = ?", sid) }

	before_create :number_story

	def push!
		s = nil
		if self.sprint.nil?
			s = self.project.first_sprint
		else
			s = self.sprint.next_sprint
		end
		while s && s.complete?
			s = s.next_sprint
		end
		if s
			os = self.sprint
			self.sprint = s
			self.number = 99999
			self.save
			if os
				os.renumber!
			else
				self.project.renumber_backlog!
			end
			self.sprint.renumber! if self.sprint
		end
	end

	def pull!
		if self.sprint.nil?
			return
		end
		s = self.sprint.previous_sprint
		while s && s.complete?
			s = s.previous_sprint
		end
		os = self.sprint
		self.sprint = s
		self.number = 99999
		self.save
		if self.sprint
			self.sprint.renumber!
		else
			self.project.renumber_backlog!
		end
		os.renumber!
	end

	def complete?
		return self.status == "completed" || self.status == "rolled"
	end

	def display_status
		self.status.to_s.titleize rescue "unknown"
	end

	def status
		if approved?
			si_map = sub_items.map { |si| si.status }
			if si_map.include?("waiting")
				"waiting"
			elsif (si_map - ["rolled"]).empty?
				"rolled"
			elsif (si_map - ["rolled", "completed"]).empty?
				"completed"
			elsif si_map.any? { |si| ["in_progress", "completed", "rolled"].include?(si) }
				"in_progress"
			else
				"approved"
			end
		else
			"open"
		end
	end

	def display_number
		if self.sprint
			"#{self.sprint.number}.#{self.number}"
		else
			"0.#{self.number}"
		end
	end

	def last_item_number
		self.sub_items.last.number rescue 0
	end

	private

	def number_story
		if self.sprint
			self.number = self.sprint.last_story_number + 1
		elsif self.project
			self.number = self.project.last_backlog_story_number + 1
		else
			self.number = 0
		end
	end

end
