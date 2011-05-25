class CreateDebts < ActiveRecord::Migration
  def self.up
    create_table :debts do |t|
      t.string :name
      t.string :description
      t.datetime :service_date

      t.timestamps
    end
  end

  def self.down
    drop_table :debts
  end
end
