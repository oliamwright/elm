module StoriesHelper

	def story_url(story)
		if story.sprint.nil?
			backlog_project_url(story.project)
		else
			project_sprint_url(story.project, story.sprint)
		end
	end

end
