class AddApprovedToStories < ActiveRecord::Migration
  def change
		add_column :stories, :approved, :boolean
  end
end
