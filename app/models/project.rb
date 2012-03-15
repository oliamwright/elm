class Project < ActiveRecord::Base
	
	include ProjectCan
	include ProjectPermissions

	has_many :role_memberships
	has_many :users, :through => :role_memberships
	has_many :roles, :through => :role_memberships
	belongs_to :owner, :class_name => 'User'
	has_many :phases, :dependent => :destroy
	has_many :sprints, :dependent => :destroy
	has_many :stories, :dependent => :destroy
	has_many :sub_items, :through => :stories
	belongs_to :client, :class_name => 'Company'
	has_many :log_events, :dependent => :destroy
	has_many :additional_time_items, :dependent => :destroy

	scope :for_client, lambda { |client| where("client_id = ?", client) }

	DROPBOX_FOLDER = "#{Rails.root}/dropbox"

	def renumber_backlog_if_necessary!
		nec = false
		c = 1
		self.stories.backlog.order("number asc").each do |s|
			nec = true unless s.number == c
			c += 1
		end
		if nec
			self.renumber_backlog!
		end
	end

	def renumber_backlog!
		c = 1
		self.stories.backlog.order("number asc").each do |s|
			s.number = c
			s.save
			c += 1
		end
	end

	def renumber_phases!
		c = 1
		self.phases.order('number asc').each do |p|
			p.number = c
			p.save
			c += 1
		end
	end

	def percent_backlog_complete
		return 0 if self.stories.backlog.count.to_f == 0.0
		self.stories.backlog.select { |s| s.complete? }.count.to_f / self.stories.backlog.count.to_f rescue 0
	end
	
	def display_percent_backlog_complete
		"#{(self.percent_backlog_complete * 100).to_i} %"
	end

	def percent_complete
		return 0 if self.stories.count.to_f == 0.0
		self.stories.select { |s| s.complete? }.count.to_f / self.stories.count.to_f rescue 0
	end

	def display_percent_complete
		"#{(self.percent_complete * 100).to_i} %"
	end

	def last_backlog_story_number
		self.stories.backlog.order("number asc").last.number rescue 0
	end

	def first_sprint
		fs = self.sprints.order('number asc, id asc').first
		fs
	end

	def self.dropbox_folders
		Dir.glob("#{DROPBOX_FOLDER}/*").collect { |c|
			File.directory?(c) ? c.split("/").last : nil
		}.compact.sort
	end

	def display_sprint_duration
		"#{(self.sprint_duration / 1.week rescue 0)} Week#{(self.sprint_duration / 1.week rescue 0) == 1 ? '' : 's'}"
	end

	def self.sprint_durations
		[
			["1 Week", 1.week.to_i],
			["2 Weeks", 2.weeks.to_i],
			["4 Weeks", 4.weeks.to_i]
		]
	end

	def num_sprints
		self.sprints.count
	end

	def last_sprint
		self.sprints.order('number asc, id asc').last
	end

end
