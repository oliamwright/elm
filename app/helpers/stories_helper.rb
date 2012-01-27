module StoriesHelper

	def story_url(story)
		if story.sprint.nil?
			backlog_project_url(story.project, :anchor => "s_#{story.display_number}")
		else
			project_sprint_url(story.project, story.sprint, :anchor => "s_#{story.display_number}")
		end
	end

end
