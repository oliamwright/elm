
module #CLASS#Permissions

	def self.scope
		:#CLASS#
	end

	def self.model_permissions
		[
		]
	end

	def self.included(base)
		model_permissions.each do |s,l|
			puts "#{scope} : #{s.to_s} : #{l}"
			Permission.find_or_create_by_scope_and_short_name_and_long_description(scope, s.to_s, l)
		end
	end

end
