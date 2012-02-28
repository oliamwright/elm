class AdditionalTimeItem < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
	belongs_to :sprint

	scope :for_project, lambda { |pid| where("project_id = ?", pid) }
	scope :for_user, lambda { |uid| where("user_id = ?", uid) }
	scope :for_sprint, lambda { |sid| where("sprint_id = ?", sid) }

	def formatted_time
		"%0.02f" % self.time rescue "0.00"
	end
end
