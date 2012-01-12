class AddFieldsToProject < ActiveRecord::Migration
  def self.up
		add_column :projects, :start_date, :date
		add_column :projects, :end_date, :date
		add_column :projects, :duration, :integer
		add_column :projects, :sprint_duration, :integer
  end

  def self.down
		remove_column :projects, :sprint_duration
		remove_column :projects, :duration
		remove_column :projects, :end_date
		remove_column :projects, :start_date
  end
end
