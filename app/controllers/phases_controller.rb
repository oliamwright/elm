class PhasesController < ApplicationController

	def create
		if @project
			@phase = Phase.new
			@phase.number = (@project.phases.last.number + 1 rescue 1)
			@phase.project = @project
			@phase.save
			s = Sprint.new
			s.phase = @phase
			s.project = @project
			s.number = 1
			s.save
		end
		redirect_to project_sprints_url(@project)
	end

	def update
		@phase = Phase.find(params[:id]) rescue nil
		if @phase
			respond_to do |format|
				if @phase.update_attributes(params[:phase])
					format.html { redirect_to(project_sprints_url(@phase.project), :notice => "Phase '#{@phase.display_name}' updated.") }
					format.json { respond_with_bip(@phase) }
				else
					format.html { }
					format.json { respond_with_bip(@phase) }
				end
			end
		end
	end

	def destroy
		@phase = Phase.find(params[:id]) rescue nil
		@project = @phase.project
		if current_user.can?(:delete, @phase)
			if @phase
				@phase.sprints.each do |sprint|
					sprint.stories.each do |story|
						story.sprint = nil
						story.save
					end
					sprint.destroy
				end
				@phase.destroy
			end
			@project.renumber_phases!
		end
		redirect_to project_sprints_url(@project)
	end

end
