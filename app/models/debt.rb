class Debt < ActiveRecord::Base
	belongs_to :user
	has_many :events

	def event_objects
		events.map(&:event_object)
	end
end
