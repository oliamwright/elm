class Role < ActiveRecord::Base
	include RoleCan
	include RolePermissions

	has_many :role_memberships
	has_many :users, :through => :role_memberships
	has_and_belongs_to_many :permissions

	scope :global, where("role_memberships.project_id is null")
	scope :local, where("role_memberships.project_id is not null")
	scope :for_project, lambda { |project| where("role_memberships.project_id = ?", project) }
	scope :all_for_project, lambda { |project| where("role_memberships.project_id = ? or role_memberships.project_id is null", project) }
	scope :primary, where("role_memberships.primary = 1")

	def force_touch
		self.touch
		self.users.each do |u|
			u.touch
		end
	end

	def self.special(name)
		Role.find_by_name(name.to_s.titleize)
	end

	def self.Admin
		self.special(:admin)
	end

	def self.Anyone
		self.special(:anyone)
	end

	def self.ClientTeam
		self.special(:client_team)
	end

	def self.ProjectTeam
		self.special(:project_team)
	end

	def self.ProjectOwner
		self.special(:project_owner)
	end

	def self.Debug
		self.special(:debug)
	end

	def self.Developer
		self.special(:developer)
	end

	def self.ScrumMaster
		self.special(:scrum_master)
	end

	def full_name
		"#{self.name} (#{self.internal_name})"
	end

end
