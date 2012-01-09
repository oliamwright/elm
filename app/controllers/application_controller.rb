class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :authenticate_user!, :except => [ :home ]
	before_filter :get_version
	before_filter :load_project
	before_filter :assert_authority!, :except => [ :home ]
	before_filter :assert_guid!

	def home
	end

	private

	def assert_guid!
		current_user.assert_guid! if current_user
	end

	def load_project
		puts "loading project..."
		if params.has_key?(:project_id)
			@project = Project.find(params[:project_id]) rescue nil
		else
			@project = Project.find(params[:id]) rescue nil
		end
		unless @project && current_user.can?(:show, @project)
			@project = nil
		end
		if @project
			puts "loaded Project/#{@project.id} (#{@project.name})"
			if !current_user.nil?
				current_user.current_project = @project
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

		unless current_user.class_permission?(@project, scope, perm)
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
