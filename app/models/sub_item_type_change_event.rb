class SubItemTypeChangeEvent < LogEvent

	def init(user, item, old_type, new_type)
		self.user = user
		self.sub_item = item
		self.project = item.story.project
		self.data[:old_type] = old_type
		self.data[:new_type] = new_type
		self
	end

	def detail_string
		"#{self.ts_string} #{self.user.full_name} changed '#{self.sub_item.display_number}' from '#{self.data[:old_type]}' to '#{self.data[:new_type]}'"
	end
end

