class Tagging < ActiveRecord::Migration
  def self.up
		create_table :taggings do |t|
			t.integer :tag_id
			t.integer :transaction_id
			t.float :amount
			t.timestamps
		end
  end

  def self.down
		drop_table :taggings
  end
end
