
module ProjectCan
	# Instance Methods
	def can?(action, user)
		if self.respond_to?("can_#{action}?".to_sym)
			return self.send("can_#{action}?".to_sym, user)
		end
		return :default
	end
end

