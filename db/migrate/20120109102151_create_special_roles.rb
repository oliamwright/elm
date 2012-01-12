class CreateSpecialRoles < ActiveRecord::Migration
  def self.up
		[:admin, :anyone, :client_team, :project_team, :project_owner].each do |role_sym|
			role_name = role_sym.to_s.titleize
			unless Role.special(role_sym)
				r = Role.new
				r.name = role_name
				r.save
				puts "Special role '#{role_name}' created."
			else
				puts "Special role '#{role_name}' already exists."
			end
		end
  end

  def self.down
		[:admin, :anyone, :client_team, :project_team, :project_owner].each do |role_sym|
			r = Role.special(role_sym)
			if r
				r.destroy
			end
		end
  end
end
