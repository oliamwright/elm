class AddDefaultToAdditionalTimeItems < ActiveRecord::Migration
  def change
		change_column :additional_time_items, :time, :float, :default => 0.0

		AdditionalTimeItem.all.each do |ati|
			ati.time = 0.0
			ati.save!
		end
  end
end
