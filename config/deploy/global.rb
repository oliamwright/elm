
load 'config/deploy/unicorn'
load 'config/deploy/release'
require 'bundler/capistrano'

namespace :deploy do
	
	task :test_path, :roles => :app do
		run "env | grep -i path"
	end

	desc "deploy application"
	task :start, :roles => :app do
	end

	desc "initialize application for deployment"
	task :setup, :roles => :app do
		run "cd #{deploy_to} && mkdir -p releases shared shared/pids"
	end

	desc "clone repository"
	task :setup_code, :roles => :app do
		run "cd #{deploy_to} && git clone #{repository} cache"
	end

	desc "update VERSION"
	task :update_version, :roles => :app do
		run "cd #{deploy_to}/cache && git describe --abbrev=0 HEAD > ../current/VERSION && cat ../current/VERSION"
	end

	desc "dummy update_code task"
	task :update_code, :roles => :app do
	end

	desc "update codebase"
	task :pull_repo, :roles => :app do
		run "cd #{deploy_to}/cache && git pull"
	end

	desc "symlink stylesheets-less"
	task :symlink_stylesheets_less, :roles => :app do
		run "cd #{release_path}/public && ln -s #{deploy_to}/shared/stylesheets-less/ stylesheets-less"
	end

	desc "make release directory"
	task :make_release_dir, :roles => :app do
		run "mkdir #{release_path}"
	end

	desc "copy code into release folder"
	task :copy_code_to_release, :roles => :app do
		run "cd #{deploy_to}/cache && cp -pR * #{release_path}/"
	end

	desc "bundle install gems"
	task :bundle_install, :roles => :app do
		run "cd #{release_path} && sudo bundle install"
	end

	desc "run rake:db:migrate"
	task :migrate_db, :roles => :app do
		run "cd #{release_path} && RAILS_ENV=production NO_PERMS=1 bundle exec rake db:migrate"
	end

	desc "run rake roles:default_permissions"
	task :rake_perms, :roles => :app do
		run "cd #{release_path} && RAILS_ENV=production bundle exec rake roles:default_permissions"
	end

	desc "restart server"
	task :restart, :roles => :app do
		#run "cd #{deploy_to}/current && mongrel_rails cluster::restart"
		unicorn.restart
	end

	desc "make tmp directories"
	task :make_tmp_dirs, :roles => :app do
		run "cd #{deploy_to}/current && mkdir -p tmp/pids tmp/sockets"
	end

	desc "symlink pids directory"
	task :symlink_pids_dir, :roles => :app do
		run "cd #{release_path}/tmp && ln -s #{deploy_to}/shared/pids"
	end

	desc "symlink database.yml"
	task :symlink_database_yml, :roles => :app do
		run "cd #{release_path}/config && ln -s _database.yml database.yml"
	end

	desc "symlink initializers"
	task :symlink_initializers, :roles => :app do
		run "cd #{release_path}/config/initializers && ln -s #{deploy_to}/shared/config/initializers/site_keys.rb"
	end

	desc "symlink beeing"
	task :symlink_beeing, :roles => :app do
		run "cd #{release_path}/public && ln -s /var/www/beeing/rel/beeing/www chat"
	end

	task :finalize_update, :roles => :app do
	end
end

after 'deploy:setup', 'deploy:setup_code'
after 'deploy:pull_repo', 'deploy:copy_code_to_release'
before 'deploy:update_code', 'deploy:pull_repo'
after 'deploy:update_code', 'deploy:finalize_update'
before 'deploy:copy_code_to_release', 'deploy:make_release_dir'
#after 'deploy:copy_code_to_release', 'deploy:bundle_install'
before 'deploy:restart', 'deploy:migrate_db'
after 'deploy:migrate_db', 'deploy:rake_perms'
#before 'deploy:migrate_db', 'deploy:symlink_database_yml'
before 'deploy:symlink_database_yml', 'deploy:symlink_initializers'
#after 'deploy:symlink_database_yml', 'deploy:symlink_beeing'
after 'deploy:symlink', 'deploy:update_version'
after 'deploy:symlink', 'symlink_stylesheets_less'

after 'deploy:symlink', 'deploy:make_tmp_dirs'

