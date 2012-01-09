class ProjectsController < ApplicationController

	def index
		if current_user.can?(:new, Project)
			@projects = Project.all
		else
			@projects = current_user.projects
		end
	end

end
