class AddTagsTransactionsJoinTable < ActiveRecord::Migration
  def self.up
		create_table :tags_transactions, :id => false do |t|
			t.integer :tag_id
			t.integer :transaction_id
		end
  end

  def self.down
		drop_table :tags_transactions
  end
end
