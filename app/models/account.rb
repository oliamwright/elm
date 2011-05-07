class Account < ActiveRecord::Base
  belongs_to :user
	has_many :transactions
	has_many :tags

	scope :for_user, lambda { |user|
		where("accounts.user_id = ?", user.id)
	}

	def cash_balance_on(date)
		Transaction.where("account_id = ? and transaction_date <= ?", self.id, date).all.map(&:taggings).flatten.select { |t| t.tag.name == "cash"}.inject(0) { |s,v| s+=v.amount }
	end

	def cash_balance
		transactions.map(&:taggings).flatten.select { |t| t.tag.name == "cash" }.inject(0) { |s,v| s+=v.amount }
	end

	def balance
		Transaction.where(:account_id => self.id).sum(:amount).round(2)
	end

	def balance_on(date)
		Transaction.where("account_id = ? and transaction_date <= ?", self.id, date).sum(:amount).round(2)
	end

	def balance_type
		if balance >= 0
			"positive"
		else
			"negative"
		end
	end
end
