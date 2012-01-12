class Project < ActiveRecord::Base
	
	include ProjectCan
	include ProjectPermissions

	has_many :role_memberships
	has_many :users, :through => :role_memberships
	has_many :roles, :through => :role_memberships
	belongs_to :owner, :class_name => 'User'

	scope :for_client, lambda { |client| where("client = ?", client) }

	DROPBOX_FOLDER = "#{Rails.root}/dropbox"

	def self.dropbox_folders
		Dir.glob("#{DROPBOX_FOLDER}/*").collect { |c|
			File.directory?(c) ? c.split("/").last : nil
		}.compact.sort
	end

	def self.sprint_durations
		[
			["1 Week", 1.week.to_i],
			["2 Weeks", 2.weeks.to_i],
			["4 Weeks", 4.weeks.to_i]
		]
	end

	def num_sprints
		self.duration / (self.sprint_duration / 1.week)
	end

end
