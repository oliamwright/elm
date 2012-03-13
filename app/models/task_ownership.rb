class TaskOwnership < ActiveRecord::Base
  belongs_to :user
  belongs_to :sub_item, :touch => true

	scope :for_sprint, lambda { |s| joins(:sub_item).joins("INNER JOIN stories ON sub_items.story_id = stories.id").where("stories.sprint_id = ?", s) }
	scope :not_ignored, joins(:sub_item).where("not status = 'ignored'")
	scope :not_bugs, joins(:sub_item).where("not item_type = 'bug'")
	scope :bugs, joins(:sub_item).where("item_type = 'bug'")

	def assigned_time
		unless self.actual_time > 0
			return 0.0
		end
		to_count = [self.sub_item.task_ownerships.select { |to| to.actual_time > 0 }.count, 1].max
		self.sub_item.estimated_time / to_count
	end

	def display_actual_time
		"%0.02f" % self.actual_time
	end
end
