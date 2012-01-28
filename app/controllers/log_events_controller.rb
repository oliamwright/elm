class LogEventsController < ApplicationController
	
	skip_before_filter :assert_authority!, :only => [:index]

	def index
		if @project
			@events = @project.log_events.order("created_at desc").all
		else
			@events = LogEvent.order("created_at desc").all
		end
	end

end
