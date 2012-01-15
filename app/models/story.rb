class Story < ActiveRecord::Base

	belongs_to :owner, :class_name => 'User'
	belongs_to :project
	belongs_to :sprint

end
