class BecomeUserEvent < LogEvent

	def init(user, other_user)
		self.user = user
		self.data[:other_user_id] = other_user.id
		self
	end

	def detail_string
		"#{self.ts_string} #{self.user.full_name} became '#{User.find(self.data[:other_user_id]).full_name}'."
	end

end

