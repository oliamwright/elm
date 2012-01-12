
module ProjectPermissions

	def self.scope
		:project
	end

	def self.model_permissions
		[
			[:index, 'can list projects'],
			[:show, 'can view a project'],
			[:new, 'can create projects'],
			[:create, 'can save new projects'],
			[:edit, 'can edit projects'],
			[:update, 'can update projects']
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
