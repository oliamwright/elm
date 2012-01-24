class TaskOwnership < ActiveRecord::Base
  belongs_to :user
  belongs_to :sub_item

	def display_actual_time
		"%0.02f" % self.actual_time
	end
end
