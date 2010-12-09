class Account < ActiveRecord::Base
  belongs_to :user
	has_many :transactions

	scope :for_user, lambda { |user|
		where("accounts.user_id = ?", user.id)
	}

	def balance
		Transaction.where(:account_id => self.id).sum(:amount)
	end

	def balance_type
		if balance >= 0
			"positive"
		else
			"negative"
		end
	end
end
