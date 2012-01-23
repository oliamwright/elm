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
		if @project.end_date.nil? && !@project.duration.nil? && @project.duration > 0
			@project.end_date = @project.start_date + @project.duration.weeks
		elsif @project.start_date && @project.end_date
			@project.duration = (@project.end_date - @project.start_date).to_i / 7
		end
		if @project.save
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

	def backlog
	end

	def test_output
	end

end
