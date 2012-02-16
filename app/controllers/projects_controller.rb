class ProjectsController < ApplicationController

	def index
		if current_user.can?(:new, Project)
			@projects = Project.all
		else
			@projects = current_user.projects
		end
	end

	def new
		require_perm!(current_user.can?(:create, Project)) || return
		@project = Project.new
		@project.start_date = Date.today + (1 - Date.today.wday).days
	end

	def create
		require_perm!(current_user.can?(:create, Project)) || return
		@project = Project.new(params[:project])
		@project.owner = current_user
		if @project.end_date.nil? && !@project.duration.nil? && @project.duration > 0
			@project.end_date = @project.start_date + @project.duration.weeks
		elsif @project.start_date && @project.end_date
			@project.duration = (@project.end_date - @project.start_date).to_i / 7
		end
		if @project.save
			e = ProjectCreationEvent.new.init(current_user, @project)
			e.save
			rm = RoleMembership.new
			rm.project = @project
			rm.user = current_user
			rm.role = Role.ProjectOwner
			rm.save
			flash[:notice] = "Project '#{@project.name}' created."
			redirect_to backlog_project_url(@project)
			return
		else
			flash[:error] = "Project '#{@project.name}' could not be created."
			render :action => :new
		end
	end

	def update
		@project = Project.find(params[:id])
		require_perm!(current_user.can?(:edit, @project)) || return
		if @project
			if params[:project][:duration]
				@project.duration = params[:project][:duration].to_i
				if @project.start_date
					@project.end_date = @project.start_date + @project.duration.weeks
				end
				params[:project].delete(:duration)
				@project.save
				respond_with_bip(@project)
				return
			elsif params[:project][:end_date]
				@project.end_date = Date.strptime(params[:project][:end_date], "%m/%d/%Y")
				params[:project].delete(:end_date)
				if @project.start_date
					@project.duration = (@project.end_date - @project.start_date).to_i.days / 1.week
				end
				@project.save
				respond_with_bip(@project)
				return
			elsif params[:project][:start_date]
				@project.start_date = Date.strptime(params[:project][:start_date], "%m/%d/%Y")
				params[:project].delete(:start_date)
				if @project.duration
					@project.end_date = @project.start_date + @project.duration.weeks
				end
				@project.save
				respond_with_bip(@project)
				return
			else
				respond_to do |format|
					if @project.update_attributes(params[:project])
						format.html { redirect_to(@project, :notice => "Project '#{@project.name}' updated.") }
						format.json { respond_with_bip(@project) }
					else
						format.html { }
						format.json { respond_with_bip(@project) }
					end
				end
			end
		end
	end

	def team
		@project = Project.find(params[:id]) rescue nil
		require_perm!(current_user.can?(:show, @project)) || return
	end

	def sprints
		@project = Project.find(params[:id]) rescue nil
		require_perm!(current_user.can?(:show, @project)) || return
	end

	def backlog
		@project = Project.find(params[:id]) rescue nil
		require_perm!(current_user.can?(:show, @project)) || return
		require_perm!(current_user.can?(:show_backlog, @project)) || return
		@project.renumber_backlog_if_necessary!
	end

	def test_output
	end

end
