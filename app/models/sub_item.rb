class SubItem < ActiveRecord::Base

	include SubItemCan
	include SubItemPermissions

  belongs_to :story
	belongs_to :owner, :class_name => 'User'

	scope :bugs, where("item_type = 'bug'")
	scope :tasks, where("item_type = 'task'")

	before_create :number_item

	def display_number
		if self.story
			"#{self.story.display_number}.#{self.number}"
		else
			"#{self.number}"
		end
	end

	private

	def number_item
		if self.story
			self.number = self.story.last_item_number + 1
		else
			self.number = 0
		end
	end

end
