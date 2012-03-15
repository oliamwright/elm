
module PhasePermissions

	def self.scope
		:phase
	end

	def self.model_permissions
		[
			[:delete, 'can delete a phase'],
			[:rename, 'can rename a phase'],
			[:create, 'can create a phase']
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
