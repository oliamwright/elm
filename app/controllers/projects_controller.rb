class ProjectsController < ApplicationController

	def search
		project_id = params[:id]
		@project = Project.find(project_id) rescue nil
		query = params[:search]
		@query = query
		q = Story.search do
			with(:project_id, project_id)
			order_by :sprint_id, :asc
			order_by :number, :asc
			fulltext query
		end
		@stories = q.results
		q = SubItem.search do
			with(:project_id, project_id)
			order_by :sprint_id, :asc
			order_by :number, :asc
			fulltext query
		end
		@sub_items = q.results
		if @stories.count == 0 and @sub_items.count == 1
			item = @sub_items.first
			if item.story.sprint.nil?
				redirect_to backlog_project_url(item.story.project, :anchor => "si_#{item.display_number}")
			else
				redirect_to project_sprint_url(item.story.project, item.story.sprint, :anchor => "si_#{item.display_number}")
			end
		elsif @sub_items.count == 0 and @stories.count == 1
			story = @stories.first
			if story.sprint.nil?
				redirect_to backlog_project_url(story.project, :anchor => "s_#{story.display_number}")
			else
				redirect_to project_sprint_url(story.project, story.sprint, :anchor => "s_#{story.display_number}")
			end
		end
	end

	def index
		if current_user.can?(:new, Project)
			@projects = Project.all
		else
			@projects = current_user.projects.uniq
		end
	end

	def new
		require_perm!(current_user.can?(:create, Project)) || return
		@project = Project.new
		@project.start_date = Date.today + (1 - Date.today.wday).days
	end

	def destroy
		@project = Project.find(params[:id]) rescue nil
		require_perm!(current_user.can?(:delete, @project)) || return
		@project.destroy
		redirect_to projects_url
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
			ph = Phase.new
			ph.name = 'Phase 1'
			ph.description = 'Phase 1'
			ph.number = 1
			ph.project = @project
			ph.save

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
		require_perm!(current_user.can?(:show_team_tab, @project)) || return
	end

	def sprints
		@project = Project.find(params[:id]) rescue nil
		require_perm!(current_user.can?(:show, @project)) || return
		require_perm!(current_user.can?(:show_sprints, @project)) || return
	end

	def backlog
		@project = Project.find(params[:id]) rescue nil
		require_perm!(current_user.can?(:show, @project)) || return
		require_perm!(current_user.can?(:show_sprints, @project)) || return
		@project.renumber_backlog_if_necessary!
	end

	def test_output
	end

end
