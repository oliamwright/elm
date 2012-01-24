class CreateTaskOwnerships < ActiveRecord::Migration
  def change
    create_table :task_ownerships do |t|
      t.references :user
      t.references :sub_item
      t.float :actual_time, :default => 0.0

      t.timestamps
    end
    add_index :task_ownerships, :user_id
    add_index :task_ownerships, :sub_item_id
  end
end
