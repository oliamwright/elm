class CreatePhoneCalls < ActiveRecord::Migration
  def self.up
    create_table :phone_calls do |t|
      t.string :name
      t.string :phone_number
      t.string :summary
      t.string :content

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_calls
  end
end
