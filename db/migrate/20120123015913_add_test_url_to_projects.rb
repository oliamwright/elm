class AddTestUrlToProjects < ActiveRecord::Migration
	def change
		add_column :projects, :test_output_url, :string
	end
end
