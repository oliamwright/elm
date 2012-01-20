class CreateStatusTransitions < ActiveRecord::Migration
  def change
    create_table :status_transitions do |t|
      t.references :sub_item
      t.references :user
      t.string :from_status
      t.string :to_status

      t.timestamps
    end
    add_index :status_transitions, :sub_item_id
    add_index :status_transitions, :user_id
  end
end
