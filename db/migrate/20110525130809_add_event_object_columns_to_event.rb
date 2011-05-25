class AddEventObjectColumnsToEvent < ActiveRecord::Migration
  def self.up
		add_column :events, :event_object_id, :integer
		add_column :events, :event_object_type, :string
  end

  def self.down
		remove_column :events, :event_object_type
		remove_column :events, :event_object_id
  end
end
