class FixPermissionsInvolvingObsoleteRolledStatus < ActiveRecord::Migration
  def up
		Permission.all.select { |p| p.short_name =~ /rolled/ }.each do |p|
			p.short_name = p.short_name.gsub(/rolled/, "dev")
			p.long_description = p.long_description.gsub(/rolled/, "dev")
			p.save
		end
		SubItem.all.select { |p| p.status == "rolled" }.each do |si|
			si.status = "dev"
			si.save
		end
  end

  def down
  end
end
