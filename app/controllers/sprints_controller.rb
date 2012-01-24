class SprintsController < ApplicationController
	
	def index
		@sprint = @project.first_sprint
		while @sprint and @sprint.complete?
			@sprint = @sprint.next_sprint
		end
		if @sprint
			render :action => 'show'
		end
	end

	def show
		@sprint = Sprint.find(params[:id]) rescue nil
	end

end
