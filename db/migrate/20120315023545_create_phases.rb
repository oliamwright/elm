class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|
      t.string :name
      t.string :description
      t.references :project
      t.integer :number

      t.timestamps
    end
    add_index :phases, :project_id
  end
end
