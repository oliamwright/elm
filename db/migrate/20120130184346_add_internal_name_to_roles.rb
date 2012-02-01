class AddInternalNameToRoles < ActiveRecord::Migration
  def up
		add_column :roles, :internal_name, :string
		Role.all.each do |r|
			r.internal_name = r.name
			r.save
		end
  end

	def down
		remove_column :roles, :internal_name
	end
end
