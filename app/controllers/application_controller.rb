class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :authenticate_user!, :except => [ :home ]
	before_filter :get_version
	before_filter :load_project
	#before_filter :assert_authority!, :except => [ :home ]
	before_filter :assert_guid!
	before_filter :update_page_history
	before_filter :check_css

	def home
		if current_user && @project
			redirect_to backlog_project_url(@project)
		elsif !current_user
			redirect_to new_user_session_url
		end
	end

	private

	def check_css
		if !APP_CONFIG['check_css']
			puts "recompilation of css disabled"
			return
		end
		modified = false
		Dir.glob("#{Rails.root}/public/stylesheets-less/*.less").each do |file|
			bfile = File.basename(file)
			dfile = "#{Rails.root}/public/stylesheets/less/#{bfile}"
			puts "stylesheet: #{bfile}"
			stime = File.mtime(file)
			dtime = File.mtime(dfile)
			if stime >= dtime
				puts "MODIFIED!"
				modified = true
				FileUtils.cp(file, dfile)
			end
		end
		if modified
			recompile_stylesheet
			if APP_CONFIG['auto_commit_css']
				commit_style_changes
			end
		end
	end

	def recompile_stylesheet
		puts "recompiling stylesheet"
		`cd "#{Rails.root}/public/stylesheets/less" && bundle exec lessc "#{Rails.root}/public/stylesheets/less/homebrew.less" > "#{Rails.root}/public/stylesheets/homebrew.css"`
	end

	def commit_style_changes
		puts "committing style changes"
		Dir.glob("#{Rails.root}/public/stylesheets-less/*.less").each do |file|
			bfile = File.basename(file)
			dfile = "/var/www/homebrew/cache/public/stylesheets/less/#{bfile}"
			FileUtils.cp(file, dfile)
		end
		`cd "/var/www/homebrew/cache/" && git add public/stylesheets/less/*less && git add public/stylesheets/homebrew.css && git commit -m "auto style commit" && git push`
	end

	def update_page_history
		unless session[:page_history]
			session[:page_history] = []
		end

		only_methods = [ "GET" ]
		skip_actions = [ "edit", "new", "assign_project_role", "assign_role", "grant", "revoke" ]
		skip_controllers = [ "charts" ]

		if only_methods.include?(request.method) and !skip_actions.include?(request.parameters[:action]) and !skip_controllers.include?(request.parameters[:controller]) and !request.xhr?
			session[:page_history].delete_if { |ph| ph == request.url }
			session[:page_history].unshift(request.url)
			session[:page_history] = session[:page_history][0,5]
		end
	end

	def redirect_to_last_page(options = {})
		if session[:page_history] and session[:page_history][0]
			redirect_to session[:page_history][0], options
		else
			redirect_to :back, options
		end
	end

	def build_date_from_params(field_name, params)
		field_name = field_name.to_s
		Date.new(params["#{field_name}(1i)"].to_i,
			params["#{field_name}(2i)"].to_i,
			params["#{field_name}(3i)"].to_i
		)
	end

	def assert_guid!
		current_user.assert_guid! if current_user
	end

	def load_project
		puts "loading project..."
		if params.has_key?(:project_id)
			@project = Project.find(params[:project_id]) rescue nil
		elsif params[:controller] == 'projects'
			@project = Project.find(params[:id]) rescue nil
		end
		unless @project || !session.has_key?(:current_project_id)
			@project = Project.find(session[:current_project_id]) rescue nil
		end
		unless @project && current_user.can?(:show, @project)
			@project = nil
		end
		if @project
			puts "loaded Project/#{@project.id} (#{@project.name})"
			if !current_user.nil?
				current_user.current_project = @project
				session[:current_project_id] = @project.id
			end
		else
			puts "failed"
		end
	end

	def require_perm!(has_perm)
		unless has_perm
			flash[:error] = 'You are not authorized.'
			redirect_to root_url
			return false
		end
		return true
	end

	def assert_authority!
		puts "asserting authority..."
		action = params[:action].to_sym
		controller = params[:controller]
		id = params[:id]

		if !id.nil?
			# defer to object-level perms
			return true
		end

		object = controller.to_s.camelcase.singularize.constantize rescue nil
		scope = controller.to_s.singularize.underscore.to_sym
		perm = action

		if controller =~ /^devise/
			puts "ok"
			return true
		end

		unless current_user.class_permission?(scope, perm, @project)
			puts "failed"
			flash[:error] = 'You are not authorized.'
			redirect_to root_url
			return
		end

		puts "ok"
		return true
	end

	def after_sign_in_path_for(resource)
		root_path
	end

	def get_version
		@VERSION = %x[cd #{Rails.root.to_s} && cat VERSION]
		if @VERSION.nil?
			@VERSION = "none"
		end
		@VERSION.chomp!
		if Rails.env == "development"
			@VERSION += " [dev]"
		end
		if Rails.env == "test"
			@VERSION += " [test]"
		end
	end

	def merge_time_and_event_date(y, m, d)
		dn = DateTime.now
		DateTime.new(y, m, d, dn.hour, dn.min, dn.sec, dn.offset)
	end
end
