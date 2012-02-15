require 'spec_helper'

ADMIN_PERMS = [
	[ :role, :index ],
	[ :role, :show ],
	[ :role, :edit ],
	[ :role, :create ],
	[ :user, :index ],
	[ :user, :show ],
	[ :user, :edit ],
	[ :user, :assign_role ],
	[ :user, :unassign_role ],
	[ :user, :assign_project_role ],
	[ :user, :unassign_project_role ],
	[ :company, :index ],
	[ :company, :show ],
	[ :company, :create ],
	[ :company, :edit ],
	[ :permission, :grant ],
	[ :permission, :revoke ]
]

PROJECT_MANAGER_PERMS = [
	[ :project, :create ]
]

def setup_project_manager
	load_modules
	project_manager_role = Role.make!(:project_manager)
	@admin = User.make!
	@project_manager = User.make!
	@project_manager.roles << project_manager_role
	assign_project_manager_permissions
end

def setup_user
	@admin = User.make!
	@user = User.make!
end

def setup_admin
	load_modules
	admin_role = Role.Admin || Role.make!(:admin)
	@admin = User.make!
	@admin.roles << admin_role
	assign_admin_permissions
end

def load_modules
	Dir.glob(File.join(Rails.root, "app", "models", "*.rb")) { |file|
		unless file =~ /(_can|_permissions)/
			load file
		end
	}
end

def assign_admin_permissions
	r = Role.Admin

	ADMIN_PERMS.each do |s,p|
		assign_permission_to_role(Permission.find_by_scope_and_short_name(s.to_s, p.to_s), r)
	end
end

def assign_project_manager_permissions
	r = Role.special(:project_manager)
	PROJECT_MANAGER_PERMS.each do |s,p|
		assign_permission_to_role(Permission.find_by_scope_and_short_name(s.to_s, p.to_s), r)
	end
end

def assign_permission_to_role(perm, role)
	perm.should be_a(Permission)
	role.should be_a(Role)
	unless role.permissions.include?(perm)
		role.permissions << perm
	end
end
