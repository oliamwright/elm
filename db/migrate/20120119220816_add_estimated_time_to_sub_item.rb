class AddEstimatedTimeToSubItem < ActiveRecord::Migration
  def change
		add_column :sub_items, :estimated_time, :float, :default => 0.0
  end
end
