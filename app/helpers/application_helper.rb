module ApplicationHelper

	def permitted?(action, object, &block)
		if block_given?
			yield if current_user.can?(action, object)
		else
			if current_user.can?(action, object)
				return true
			else
				return false
			end
		end
	end

end
