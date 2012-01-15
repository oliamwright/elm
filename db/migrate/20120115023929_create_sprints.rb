class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.integer :number
      t.references :project

      t.timestamps
    end
    add_index :sprints, :project_id
  end
end
