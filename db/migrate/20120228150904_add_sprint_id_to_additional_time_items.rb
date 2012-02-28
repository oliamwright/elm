class AddSprintIdToAdditionalTimeItems < ActiveRecord::Migration
  def change
		add_column :additional_time_items, :sprint_id, :integer
		add_index :additional_time_items, :sprint_id
  end
end
