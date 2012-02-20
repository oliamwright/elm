class LogEventsController < ApplicationController
	
	skip_before_filter :assert_authority!, :only => [:index]

	def all
		require_perm!(current_user.can?(:show_recent_activity, Project)) || return
		@events = LogEvent.order("created_at desc").all
		render :action => :index
	end

	def index
		if @project
			require_perm!(current_user.can?(:show_recent_activity, @project)) || return
			@events = @project.log_events.order("created_at desc").all
		else
			if current_user.projects.count == 0
				not_found
				return
			end
			@events = LogEvent.order("created_at desc").all
		end
	end

end
