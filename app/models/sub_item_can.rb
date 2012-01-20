
module SubItemCan
	# Instance Methods
	def can?(action, user)
		if action =~ /^from_(.*)_to_(.*)$/
			from_status = $1
			to_status = $2
			return can_change_status?(from_status, to_status, user)
		end
		if self.respond_to?("can_#{action}?".to_sym)
			return self.send("can_#{action}?".to_sym, user)
		end
		return :default
	end

	def can_change_status?(f, t, user)
		if f == t
			return true
		end
		return :default
	end

#	def can_show?(user)
#		return :default
#	end

end

