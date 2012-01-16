class Story < ActiveRecord::Base

	include StoryCan
	include StoryPermissions

	belongs_to :owner, :class_name => 'User'
	belongs_to :project
	belongs_to :sprint

	scope :backlog, where("sprint_id is null")
	scope :for_sprint, lambda { |sid| where("sprint_id = ?", sid) }

	before_create :number_story

	private

	def number_story
		if self.sprint
			self.number = self.sprint.last_story_number + 1
		elsif self.project
			self.number = self.project.last_backlog_story_number + 1
		else
			self.number = 0
		end
	end

end
