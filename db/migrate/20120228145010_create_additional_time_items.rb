class CreateAdditionalTimeItems < ActiveRecord::Migration
  def change
    create_table :additional_time_items do |t|
      t.references :project
      t.references :user
      t.float :time

      t.timestamps
    end
    add_index :additional_time_items, :project_id
    add_index :additional_time_items, :user_id
  end
end
