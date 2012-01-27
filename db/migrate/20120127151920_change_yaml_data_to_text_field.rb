class ChangeYamlDataToTextField < ActiveRecord::Migration
  def up
		change_column :log_events, :yaml_data, :text
  end

  def down
		change_column :log_events, :yaml_data, :string
  end
end
