
module CompanyPermissions

	def self.scope
		:company
	end

	def self.model_permissions
		[
			[ :index, 'can list companies' ],
			[ :show, 'can view a company' ],
			[ :create, 'can save a new company' ],
			[ :edit, 'can edit a company' ]
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
