class LogEventsController < ApplicationController
	
	skip_before_filter :assert_authority!, :only => [:index]

	def index
		@events = LogEvent.order("created_at desc").all
	end

end
