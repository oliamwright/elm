class AddValueFieldsToProjects < ActiveRecord::Migration
  def self.up
		add_column :projects, :goal, :string
		add_column :projects, :value, :string
		add_column :projects, :roi, :string
  end

  def self.down
		remove_column :projects, :roi
		remove_column :projects, :value
		remove_column :projects, :goal
  end
end
