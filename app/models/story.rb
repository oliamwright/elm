class Story < ActiveRecord::Base

	include StoryCan
	include StoryPermissions

	belongs_to :owner, :class_name => 'User'
	belongs_to :project
	belongs_to :sprint
	has_many :sub_items, :dependent => :destroy
	has_many :task_ownerships, :through => :sub_items
	has_many :log_events, :dependent => :destroy
	has_many :questions, :as => :questionable, :dependent => :destroy

	scope :backlog, where("sprint_id is null")
	scope :for_sprint, lambda { |sid| where("sprint_id = ?", sid) }

	before_create :number_story

	VALUES = [ "Trivial", "Low", "Medium", "High", "Critical" ]
	VALUE_MAP = [
		[1, "Trivial"],
		[2, "Low"],
		[3, "Medium"],
		[4, "High"],
		[5, "Critical"]
	]

	searchable do
		integer :id

		text :description
		text :story_number do
			display_number
		end

		integer :number
		integer :sprint_id
		integer :project_id
		integer :owner_id
	end

	def estimated_time
		self.sub_items.sum(:estimated_time)
	end

	def display_client_value
		VALUES[self.client_value - 1]
	end

	def actual_time
		self.task_ownerships.sum(:actual_time)
	end

	def can_pull?
		if self.sprint.nil?
			return false
		end
		return true
	end

	def can_push?
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
			return true
		else
			return false
		end
	end

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
		if s && !s.complete?
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
		return ["completed", "dev", "tested", "stage", "prod"].include?(self.status)
	end

	def ignored?
		return self.status == "ignored"
	end

	def display_status
		self.status.to_s.titleize rescue "unknown"
	end

	def status
		if approved?
			si_map = sub_items.map { |si| si.status }
			if si_map.include?("waiting")
				"waiting"
			elsif (si_map - ["ignored"]).empty?
				"ignored"
			elsif (si_map - ["prod", "dev", "stage", "tested", "completed", "ignored"]).empty?
				"completed"
			elsif si_map.any? { |si| ["in_progress", "completed", "prod", "dev", "stage", "tested"].include?(si) }
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
