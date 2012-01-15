class Sprint < ActiveRecord::Base
  belongs_to :project

	def next_sprint
		ns = Sprint.where("project_id = ? and number > ?", self.project_id, self.number).order("number asc").first
		if ns.nil?
			ns = Sprint.new
			ns.project = self.project
			ns.number = self.number + 1
			ns.save
		end
		ns
	end

	def previous_sprint
		ps = Sprint.where("project_id = ? and number < ?", self.project_id, self.number).order("number desc").first
	end

	def deletable?
		self.number > (self.project.duration / (self.project.sprint_duration / 1.week))
	end
end
