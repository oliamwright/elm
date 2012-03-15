class FinishPhaseConversion < ActiveRecord::Migration
  def up
		Project.all.each do |p|
			ph = Phase.new
			ph.name = 'Auto'
			ph.number = 1
			ph.project = p
			ph.save
			p.sprints.each do |s|
				s.phase = ph
				s.save
			end
		end
  end

  def down
  end
end
