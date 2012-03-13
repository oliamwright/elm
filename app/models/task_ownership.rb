class TaskOwnership < ActiveRecord::Base
  belongs_to :user
  belongs_to :sub_item, :touch => true

	scope :for_sprint, lambda { |s| joins(:sub_item).joins("INNER JOIN stories ON sub_items.story_id = stories.id").where("stories.sprint_id = ?", s) }
	scope :not_ignored, joins(:sub_item).where("not status = 'ignored'")
	scope :not_bugs, joins(:sub_item).where("not item_type = 'bug'")
	scope :bugs, joins(:sub_item).where("item_type = 'bug'")

	def assigned_time
		to_count = self.sub_item.task_ownerships.select { |to| to.actual_time > 0 }.count
		unless self.actual_time > 0 || self.sub_item.task_ownerships.count == 1 || to_count == 0
			return 0.0
		end
		if to_count == 0
			self.sub_item.estimated_time / self.sub_item.task_ownerships.count
		else
			self.sub_item.estimated_time / to_count
		end
	end

	def display_actual_time
		"%0.02f" % self.actual_time
	end
end
