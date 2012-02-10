class TaskOwnership < ActiveRecord::Base
  belongs_to :user
  belongs_to :sub_item

	scope :for_sprint, lambda { |s| joins(:sub_item).joins("INNER JOIN stories ON sub_items.story_id = stories.id").where("stories.sprint_id = ?", s) }
	scope :not_ignored, joins(:sub_item).where("not status = 'ignored'")

	def display_actual_time
		"%0.02f" % self.actual_time
	end
end
