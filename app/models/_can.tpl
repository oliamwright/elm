
module #CLASS#Can
	# Instance Methods
	def can?(action, user)
		if self.respond_to?("can_#{action}?".to_sym)
			return self.send("can_#{action}?".to_sym, user)
		end
		return false
	end

	def can_show?(user)
		return false
	end
end

