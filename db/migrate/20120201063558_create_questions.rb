class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :questionable_type
      t.integer :questionable_id
      t.references :user
      t.string :body

      t.timestamps
    end
    add_index :questions, :user_id
  end
end
