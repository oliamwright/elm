class AddStartDateToSprints < ActiveRecord::Migration
  def change
		add_column :sprints, :start_date, :date

		Sprint.all.each do |s|
			s.start_date = s.old_start_date
			s.save
		end
  end
end
