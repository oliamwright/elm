require 'spec_helper'

def setup_roles
	Role.make!(:anyone)
	Role.make!(:admin)
end

def load_modules
	Dir.glob(File.join(Rails.root, "app", "models", "*.rb")) { |file|
		unless file =~ /(_can|_permissions)/
			load file
		end
	}
end

def assign_permissions
	assign_admin_permissions
end

def assign_admin_permissions
	admin_perms = [
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
		[ :company, :new ],
		[ :company, :create ],
		[ :company, :edit ],
		[ :company, :update ],
		[ :permission, :grant ],
		[ :permission, :revoke ]
	]

	r = Role.Admin

	admin_perms.each do |s,p|
		perm = Permission.find_by_scope_and_short_name(s.to_s, p.to_s)
		if perm
			unless r.permissions.include?(perm)
				r.permissions << perm
			end
		end
	end

end
