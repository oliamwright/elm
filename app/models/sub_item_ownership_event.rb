class SubItemOwnershipEvent < LogEvent

	def init(user, item)
		self.user = user
		self.sub_item = item
		self.project = item.story.project
		self
	end

	def detail_string
		"#{self.ts_string} #{self.user.full_name} took ownership of task '#{self.sub_item.display_number}' : #{self.sub_item.description}"
	end
end

