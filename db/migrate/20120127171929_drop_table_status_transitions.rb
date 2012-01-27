class DropTableStatusTransitions < ActiveRecord::Migration
  def up
		drop_table :status_transitions
  end

  def down
  end
end
