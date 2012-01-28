class StatusTransitionEvent < LogEvent

	def init(user, sub_item, from_status, to_status)
		self.user = user
		self.sub_item = sub_item
		self.project = sub_item.story.project
		self.data[:from_status] = from_status
		self.data[:to_status] = to_status
		self
	end

	def detail_string
		"#{self.ts_string} #{self.user.full_name} transitioned #{self.sub_item.display_number} from #{self.data[:from_status]} to #{self.data[:to_status]}" rescue "BROKEN: #{self.id}"
	end

end

