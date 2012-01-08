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

end
