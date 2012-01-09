class Project < ActiveRecord::Base
	
	include ProjectCan
	include ProjectPermissions

	has_many :role_memberships
	has_many :users, :through => :role_memberships
	has_many :roles, :through => :role_memberships

end
