
module SubItemPermissions

	def self.scope
		:sub_item
	end

	def self.status_permissions
		#SubItem::STATUSES.combination(2).map { |fp, tp| ["from_#{fp.to_s}_to_#{tp.to_s}".to_sym, "can transition sub_items from #{fp.to_s} to #{tp.to_s}"] }
		SubItem::STATUSES.repeated_permutation(2).select { |a,b| a != b }.map { |f,t| ["from_#{f}_to_#{t}".to_sym, "can transition sub_items from #{f} to #{t}"]}
	end

	def self.model_permissions
		[
			[ :create, 'can create story sub-items' ],
			[ :delete, 'can delete sub-items' ],
			[ :take_ownership, 'can take ownership of sub-items' ],
			[ :assign_ownership, 'can assign ownership of sub-items' ]
		]
	end

	def self.included(base)
		unless ENV.has_key?('NO_PERMS')
			model_permissions.each do |s,l|
				#puts "#{scope} : #{s.to_s} : #{l}"
				Permission.find_or_create_by_scope_and_short_name_and_long_description(scope, s.to_s, l)
			end
			status_permissions.each do |s,l|
				#puts "#{scope} : #{s.to_s} : #{l}"
				Permission.find_or_create_by_scope_and_short_name_and_long_description(scope, s.to_s, l)
			end
		end
	end

end
