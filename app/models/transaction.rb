class Transaction < ActiveRecord::Base
  belongs_to :account

	def short_date
		transaction_date.strftime '%Y.%m.%d'
	end

	def type
		if amount >= 0
			"income"
		else
			"expense"
		end
	end
end
