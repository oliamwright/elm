
module RolePermissions

	def self.scope
		:role
	end

	def self.model_permissions
		[
			[:index, 'can see the list of roles'],
			[:show, 'can view a role'],
			[:edit, 'can edit a role'],
			[:create, 'can create a new role']
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
