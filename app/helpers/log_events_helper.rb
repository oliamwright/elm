module LogEventsHelper

	def project_span(obj)
		if obj.class == SubItem
			project = obj.story.project
		elsif obj.class == Story
			project = obj.project
		else
			return ""
		end
		"<span class='project_name'>In project '#{link_to project.name, backlog_project_url(project)}',</span>"
	end

end
