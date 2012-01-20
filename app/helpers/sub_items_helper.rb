module SubItemsHelper

	def possible_statuses(item)
		SubItem::STATUSES.select { |s| current_user.can?("from_#{item.status.to_s}_to_#{s.to_s}".to_sym, item) }
	end

	def display_status(status)
		status.to_s.titleize
	end

end
