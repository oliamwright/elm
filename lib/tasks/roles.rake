
namespace :roles do
	task :create_special => :environment do
		[:admin, :anyone, :client_team, :project_team, :project_owner, :debug].each do |role_sym|
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
			[ :user, :index ],
			[ :user, :show ],
			[ :user, :edit ],
			[ :user, :assign_role ],
			[ :user, :unassign_role ],
			[ :user, :assign_project_role ],
			[ :user, :unassign_project_role ],
			[ :company, :index ],
			[ :company, :show ],
			[ :company, :new ],
			[ :company, :create ],
			[ :company, :edit ],
			[ :company, :update ],
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
				[ :project, :new ],
				[ :project, :create ],
				[ :project, :edit ],
				[ :project, :update ]
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

