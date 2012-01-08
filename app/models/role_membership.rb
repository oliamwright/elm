class RoleMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :project

	scope :global, where("project_id is null")
	scope :local, where("project_id is not null")
	scope :for_project, lambda { |project| where("project_id = ?", project) }
	scope :all_for_project, lambda { |project| where("project_id = ? or project_id is null", project) }

end
