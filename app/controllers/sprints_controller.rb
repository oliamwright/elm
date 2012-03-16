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
		else
			redirect_to backlog_project_url(@project)
		end
	end

	def create
		@phase = Phase.find(params[:phase_id]) rescue nil
		if @phase
			@sprint = Sprint.new
			@sprint.number = (@phase.sprints.last.number + 1 rescue 1)
			@sprint.project = @project
			@sprint.phase = @phase
			if @sprint.previous_sprint
				@sprint.start_date = @sprint.previous_sprint.end_date
			else
				@sprint.start_date = Date.today
			end
			@sprint.save
		end
		redirect_to :back
	end

	def show
		@sprint = Sprint.find(params[:id]) rescue nil
		@sprint.renumber_if_necessary!
	end

	def update
		@sprint = Sprint.find(params[:id]) rescue nil
		if @sprint
			respond_to do |format|
				if params[:sprint][:start_date]
					@sprint.start_date = Date.strptime(params[:sprint][:start_date], "%m/%d/%Y")
					params[:sprint].delete(:start_date)
					@sprint.save
					respond_with_bip(@sprint)
					return
				elsif @sprint.update_attributes(params[:sprint])
					format.html { redirect_to(@sprint, :notice => "Sprint '#{@sprint.display_name}' updated.") }
					format.json { respond_with_bip(@sprint) }
				else
					format.html { }
					format.json { respond_with_bip(@sprint) }
				end
			end
		end
	end

	def destroy
		@sprint = Sprint.find(params[:id]) rescue nil
		if current_user.can?(:delete, @sprint)
			@project = @sprint.project
			@phase = @sprint.phase
			@sprint.stories.each do |story|
				story.sprint = nil
				story.save
			end
			@sprint.destroy
			@phase.renumber!
			if @phase.sprints.count == 0
				@phase.destroy
				@project.renumber_phases!
			end
		end
		redirect_to project_sprints_url(@project)
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
