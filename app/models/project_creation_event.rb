class ProjectCreationEvent < LogEvent

	def init(user, project)
		self.user = user
		self.project = project
		self
	end

	def detail_string
		"#{self.ts_string} #{self.user.full_name} created project '#{self.project.name}'"
	end

end

