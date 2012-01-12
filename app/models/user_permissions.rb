
module UserPermissions

	def self.scope
		:user
	end

	def self.model_permissions
		[
			[:index, 'can list users'],
			[:show, 'can view a user'],
			[:assign_role, 'can assign a global role to a user'],
			[:unassign_role, 'can remove a global role from a user'],
			[:assign_project_role, 'can assign a project role to a user'],
			[:unassign_project_role, 'can remove a project role from a user']
		]
	end

	def self.included(base)
		unless ENV.has_key?('NO_PERMS')
			model_permissions.each do |s,l|
				#puts "#{scope} : #{s.to_s} : #{l}"
				Permission.find_or_create_by_scope_and_short_name_and_long_description(scope, s.to_s, l)
			end
		end
	end

end
