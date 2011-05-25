class Debt < ActiveRecord::Base
	belongs_to :user
	has_many :events


	def payments
		Payment.joins([:event => :debt]).where(["events.debt_id = ?", self.id])
	end

	def charges
		Charge.joins([:event => :debt]).where(["events.debt_id = ?", self.id])
	end

	def balance
		self.charges.sum(:amount) - self.payments.sum(:amount)
	end

	def event_objects
		events.order(['event_date asc', 'id asc']).map(&:event_object)
	end
end
