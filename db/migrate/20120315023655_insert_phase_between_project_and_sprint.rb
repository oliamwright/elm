class InsertPhaseBetweenProjectAndSprint < ActiveRecord::Migration
  def up
		add_column :sprints, :phase_id, :integer
		add_index :sprints, :phase_id
  end

  def down
  end
end
