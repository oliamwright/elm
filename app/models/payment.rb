class Payment < ActiveRecord::Base
	has_one :event, :as => :event_object

	after_create :create_event
	after_save :save_event

	def debt=(d)
		if d.class == Debt
			@debt = d
		end
	end

	def debt
		@debt
	end

	def event_date
		self.event.event_date rescue DateTime.now
	end

	def event_date=(d)
		self.event.event_date = d
	end

	private

	def create_event
		e = Event.new
		e.event_object = self
		e.debt = @debt
		self.event = e
		e.save
	end

	def save_event
		self.event.save
	end
end
