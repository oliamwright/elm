class Story < ActiveRecord::Base

	include StoryCan
	include StoryPermissions

	belongs_to :owner, :class_name => 'User'
	belongs_to :project
	belongs_to :sprint

end
