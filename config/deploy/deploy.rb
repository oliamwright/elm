set :application, "scrumbrew"
set :repository,  "git.darmasoft.net:/git/#{application}"

set :deploy_to, "/var/www/homebrew"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

ssh_options[:keys] = ['~/.ssh/deploy.darmasoft.com-id_rsa']
set :scm_username, 'git'
set :user, 'deploy'

role :web, "homebrew.darmasoft.net"                          # Your HTTP server, Apache/etc
role :app, "homebrew.darmasoft.net"                          # This may be the same as your `Web` server
role :db,  "homebrew.darmasoft.net", :primary => true # This is where Rails migrations will run

set :keep_releases, 10
set :use_sudo, false

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

load 'config/deploy/global'
