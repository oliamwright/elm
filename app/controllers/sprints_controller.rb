class SprintsController < ApplicationController
	
	before_filter :assert_project_configured
	
	def index
		unless @project
			not_found
			return
		end
		require_perm!(current_user.can?(:show_sprints, @project)) || return
		@sprint = @project.first_sprint
		while @sprint and @sprint.complete?
			@sprint = @sprint.next_sprint
		end
		if @sprint
			@sprint.renumber_if_necessary!
			render :action => 'show'
		end
	end

	def show
		@sprint = Sprint.find(params[:id]) rescue nil
		@sprint.renumber_if_necessary!
	end

	private

	def assert_project_configured
		if @project
			unless @project.start_date && @project.duration && @project.sprint_duration
				redirect_to backlog_project_url(@project)
			end
		end
	end

end
