module SubItemsHelper

	def sub_item_url(item)
		if item.story.sprint.nil?
			backlog_project_url(item.story.project, :anchor => "si_#{item.display_number}")
		else
			project_sprint_url(item.story.project, item.story.sprint, :anchor => "si_#{item.display_number}")
		end
	end

	def possible_statuses(item)
		SubItem::STATUSES.select { |s| current_user.can?("from_#{item.status.to_s}_to_#{s.to_s}".to_sym, item) }
	end

	def display_status(status)
		status.to_s.titleize
	end

end
