class CreateLogEvents < ActiveRecord::Migration
  def change
    create_table :log_events do |t|
      t.string :type
      t.references :story
      t.references :sub_item
      t.string :yaml_data
      t.references :user

      t.timestamps
    end
    add_index :log_events, :story_id
    add_index :log_events, :sub_item_id
    add_index :log_events, :user_id
  end
end
