
namespace :roles do
	task :create_special => :environment do
		[:admin, :anyone, :client_team, :project_team, :project_owner, :debug, :developer].each do |role_sym|
			role_name = role_sym.to_s.titleize
			unless Role.special(role_sym)
				r = Role.new
				r.name = role_name
				r.save
			else
				puts "Special role '#{role_name}' already exists."
			end
		end
	end

	task :assign_debug_perms => :environment do
		r = Role.special(:debug)
		if r
			Permission.all.each do |p|
				puts "granting #{p.scope.to_s.titleize}:#{p.short_name.to_s} to Debug"
				if r.permissions.include?(p)
					puts " * already granted"
				else
					r.permissions << p
				end
			end
		end
	end

	task :assign_admin_perms => :environment do
		admin_perms = [
			[ :role, :index ],
			[ :role, :show ],
			[ :role, :edit ],
			[ :role, :create ],
			[ :user, :become],
			[ :user, :index ],
			[ :user, :show ],
			[ :user, :edit ],
			[ :user, :assign_role ],
			[ :user, :unassign_role ],
			[ :user, :assign_project_role ],
			[ :user, :unassign_project_role ],
			[ :company, :index ],
			[ :company, :show ],
			[ :company, :create ],
			[ :company, :edit ],
			[ :permission, :grant ],
			[ :permission, :revoke ]
		]

		r = Role.Admin

		admin_perms.each do |s,p|
			puts "granting #{s.to_s.titleize}:#{p.to_s} to Admin"
			perm = Permission.find_by_scope_and_short_name(s.to_s, p.to_s)
			if perm
				if r.permissions.include?(perm)
					puts " * already granted"
				else
					r.permissions << perm
				end
			else
				puts " * no such permission: #{s.to_s.titleize}:#{p.to_s}"
			end
		end

	end

	task :assign_developer_perms => :environment do
		dev_perms = [
			[:sub_item, :take_ownership],
			[:sub_item, :assign_ownership],
			[:sub_item, :from_open_to_approved],
			[:sub_item, :from_approved_to_in_progress],
			[:sub_item, :from_approved_to_completed],
			[:sub_item, :from_in_progress_to_completed]
		]

		r = Role.Developer

		dev_perms.each do |s,p|
			puts "granting #{s.to_s.titleize}:#{p.to_s} to Developer"
			perm = Permission.find_by_scope_and_short_name(s.to_s, p.to_s)
			if perm
				if r.permissions.include?(perm)
					puts " * already granted"
				else
					r.permissions << perm
				end
			else
				puts " * no such permission: #{s.to_s.titleize}:#{p.to_s}"
			end
		end

	end

	task :assign_project_team_perms => :environment do
		pt_perms = [
			[:project, :show_recent_activity],
			[:project, :show_sprints],
			[:project, :show_actual_time],
			[:project, :show_estimated_time]
		]

		r = Role.find_by_name("Project Team")

		pt_perms.each do |s,p|
			puts "granting #{s.to_s.titleize}:#{p.to_s} to Project Team"
			perm = Permission.find_by_scope_and_short_name(s.to_s, p.to_s)
			if perm
				if r.permissions.include?(perm)
					puts " * already granted"
				else
					r.permissions << perm
				end
			else
				puts " * no such permission: #{s.to_s.titleize}:#{p.to_s}"
			end
		end

	end

	task :assign_project_owner_perms => :environment do
		po_perms = [
			[:project, :show_recent_activity],
			[:project, :show_sprints],
			[:project, :show_team_tab],
			[:project, :show_rtr_tab],
			[:project, :show_sow_tab]
		]

		r = Role.find_by_name("Project Owner")

		po_perms.each do |s,p|
			puts "granting #{s.to_s.titleize}:#{p.to_s} to Project Owner"
			perm = Permission.find_by_scope_and_short_name(s.to_s, p.to_s)
			if perm
				if r.permissions.include?(perm)
					puts " * already granted"
				else
					r.permissions << perm
				end
			else
				puts " * no such permission: #{s.to_s.titleize}:#{p.to_s}"
			end
		end

	end

	task :create_project_manager => :environment do
		r = Role.find_by_name('Project Manager')
		unless r
			r = Role.new
			r.name = 'Project Manager'
			r.save
		end
	end

	task :assign_pm_perms => :environment do
		r = Role.find_by_name('Project Manager')
		if r
			pm_perms = [
				[ :project, :index ],
				[ :project, :show ],
				[ :project, :create ],
				[ :project, :edit ],
			]

			pm_perms.each do |s,p|
				puts "granting #{s.to_s.titleize}:#{p.to_s} to Project Manager"
				perm = Permission.find_by_scope_and_short_name(s.to_s, p.to_s)
				if perm
					if r.permissions.include?(perm)
						puts " * already granted"
					else
						r.permissions << perm
					end
				else
					puts " * no such permission: #{s.to_s.titleize}:#{p.to_s}"
				end
			end
		end
	end

	task :default_permissions => :environment do
		Rake::Task['roles:load_models'].invoke
		Rake::Task['roles:create_special'].invoke
		Rake::Task['roles:assign_debug_perms'].invoke
		Rake::Task['roles:assign_admin_perms'].invoke
		Rake::Task['roles:assign_project_team_perms'].invoke
		Rake::Task['roles:assign_project_owner_perms'].invoke
		Rake::Task['roles:assign_developer_perms'].invoke
		Rake::Task['roles:create_project_manager'].invoke
		Rake::Task['roles:assign_pm_perms'].invoke
	end

	task :load_models => :environment do
		Dir.glob(File.join(Rails.root, "app", "models", "*.rb")) { |file|
			unless file =~ /(_can|_permissions)/
				puts "loading #{file}..."
				load file
			else
				puts "skipping #{file}..."
			end
		}
	end


end

