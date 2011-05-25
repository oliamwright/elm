class AddAmountColumnsToPaymentsAndCharges < ActiveRecord::Migration
  def self.up
		add_column :charges, :amount, :float
		add_column :payments, :amount, :float
  end

  def self.down
		remove_column :payments, :amount
		remove_column :charges, :amount
  end
end
