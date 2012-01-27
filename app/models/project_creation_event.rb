class ProjectCreationEvent < LogEvent

	def init(user, project)
		self.user = user
		self.data[:project_id] = project.id
		self
	end

	def detail_string
		"#{self.ts_string} #{self.user.full_name} created project '#{self.project.name}'"
	end

	def project
		Project.find(self.data[:project_id])
	end
end

