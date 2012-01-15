class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :description
      t.integer :number
      t.integer :owner_id
			t.integer :project_id
			t.integer :sprint_id

      t.timestamps
    end
  end
end
