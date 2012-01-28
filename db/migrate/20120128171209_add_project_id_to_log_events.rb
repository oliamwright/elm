class AddProjectIdToLogEvents < ActiveRecord::Migration
  def up
		add_column :log_events, :project_id, :integer
		LogEvent.all.each do |e|
			if e.sub_item
				e.project = e.sub_item.story.project
			elsif e.story
				e.project = e.story.project
			else
				if e.data.has_key?(:project_id)
					e.project = Project.find(e.data[:project_id])
				else
					e.project = nil
				end
			end
			e.save
		end
  end

	def down
		remove_column :log_events, :project_id
	end
end
