class ProjectsController < ApplicationController

	def index
		if current_user.can?(:new, Project)
			@projects = Project.all
		else
			@projects = current_user.projects
		end
	end

	def new
		@project = Project.new
		@project.start_date = Date.today + (1 - Date.today.wday).days
	end

	def create
		@project = Project.new(params[:project])
		@project.owner = current_user
		if @project.end_date.nil? && @project.duration > 0
			@project.end_date = @project.start_date + @project.duration.weeks
		else
			@project.duration = (@project.end_date - @project.start_date).to_i / 7
		end
		if @project.save
			rm = RoleMembership.new
			rm.project = @project
			rm.user = current_user
			rm.role = Role.ProjectOwner
			rm.save
			flash[:notice] = "Project '#{@project.name}' created."
			redirect_to team_project_url(@project)
			return
		else
			flash[:error] = "Project '#{@project.name}' could not be created."
			render :action => :new
		end
	end

	def team
		@project = Project.find(params[:id]) rescue nil
		require_perm!(current_user.can?(:show, @project)) || return
	end

end
