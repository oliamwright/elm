class AddValueToStories < ActiveRecord::Migration
  def change
		add_column :stories, :client_value, :integer, :default => 3
  end
end
