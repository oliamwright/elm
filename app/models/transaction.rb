class Transaction < ActiveRecord::Base
  belongs_to :account
	has_and_belongs_to_many :tags

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

	def tag_string
		tags.collect { |t| t.name }.join(", ")
	end

end
