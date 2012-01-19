class CreateSubItems < ActiveRecord::Migration
  def change
    create_table :sub_items do |t|
      t.string :description
      t.integer :number
      t.string :type
      t.string :status
      t.integer :owner_id
      t.references :story

      t.timestamps
    end
    add_index :sub_items, :story_id
  end
end
