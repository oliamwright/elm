class Tag < ActiveRecord::Base
	belongs_to :account
	has_many :taggings
	has_many :transactions, :through => :taggings

	def balance
		Tagging.where(:tag_id => self.id).sum(:amount).round(2)
	end

	def balance_on(date)
		Tagging.joins(:transaction).where("tag_id = ? and transaction_date <= ?", self.id, date).sum(:amount).round(2)
	end

	def rank_initial
		self.taggings.count == 1 ? -20 : self.taggings.count
	end

	def rank_income_adj
		self.income_tag? ? (-5 * self.taggings.count * 2) : 0
	end

	def rank_first
		self.taggings.inject(0) {|s,v|
			v.first_tagging? ? s+3 : s
		}
	end

	def rank_only
		self.taggings.inject(0) {|s,v|
			v.only_tagging? ? s+5 : s
		}
	end

	def rank
		rank_initial + rank_first + rank_only + rank_income_adj
	end

	def verbose_rank_string
		"#{rank_initial} count + #{rank_first}(#{rank_first/3}) first + #{rank_only}(#{rank_only/5}) only + #{rank_income_adj} income adj"
	end

	def income_tag?
		self.transactions.sum(:amount) > 0
	end
end
