
module ProjectPermissions

	def self.scope
		:project
	end

	def self.model_permissions
		[
			[:index, 'can list projects'],
			[:show, 'can view a project'],
			[:show_payables, 'can view payables for a project'],
			[:show_receivables, 'can view receivables for a project'],
			[:show_project_financials, 'can view financial fields for a project'],
			[:show_sprints, 'can view sprints for project'],
			[:show_estimated_time, 'can view estimated time for a project'],
			[:show_actual_time, 'can view actual time for a project'],
			[:show_allocations, 'can view resource allocations for a project'],
			[:show_recent_activity, 'can view recent activity for a project'],
			[:show_team_tab, 'can view team tab for project'],
			[:show_rtr_tab, 'can view rtr tab for project'],
			[:show_sow_tab, 'can view sow tab for project'],
			[:create, 'can create new projects'],
			[:edit, 'can edit projects'],
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
