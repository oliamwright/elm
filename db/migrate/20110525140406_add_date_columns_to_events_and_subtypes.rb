class AddDateColumnsToEventsAndSubtypes < ActiveRecord::Migration
  def self.up
		add_column :events, :event_date, :datetime
  end

  def self.down
		drop_column :events, :event_date
  end
end
