class UserStoryCreationEvent < LogEvent

	def init(user, story)
		self.user = user
		self.story = story
		self.project = story.project
		self
	end

	def detail_string
		"#{self.ts_string} #{self.user.full_name} created story '#{self.story.display_number}' for project '#{self.story.project.name}' : #{self.story.description}"
	end
end

