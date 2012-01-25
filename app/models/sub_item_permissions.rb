
module SubItemPermissions

	def self.scope
		:sub_item
	end

	def self.model_permissions
		[
			[ :create, 'can create story sub-items' ],
			[ :from_open_to_approved, 'can move sub-items from open to approved' ],
			[ :from_open_to_waiting, 'can move sub-items from open to waiting' ],
			[ :from_open_to_ignored, 'can move sub-items from open to ignored' ],
			[ :from_approved_to_waiting, 'can move sub-items from approved to waiting' ],
			[ :from_approved_to_in_progress, 'can move sub-items from approved to in_progress' ],
			[ :from_approved_to_ignored, 'can move sub-items from approved to ignored' ],
			[ :from_approved_to_completed, 'can move sub-items from approved to completed' ],
			[ :from_waiting_to_in_progress, 'can move sub-items from waiting to in_progress' ],
			[ :from_waiting_to_ignored, 'can move sub-items from waiting to ignored' ],
			[ :from_in_progress_to_completed, 'can move sub-items from in_progress to completed' ],
			[ :from_in_progress_to_ignored, 'can move sub-items from in_progress to ignored' ],
			[ :from_completed_to_ignored, 'can move sub-items from completed to ignored' ],
			[ :from_completed_to_rolled, 'can move sub-items from completed to rolled' ],
			[ :from_ignored_to_open, 'can move sub-items from ignored to open' ],
			[ :take_ownership, 'can take ownership of sub-items' ]
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
