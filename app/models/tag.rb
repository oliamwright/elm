class Tag < ActiveRecord::Base
	belongs_to :account
	has_many :taggings
	has_many :transactions, :through => :taggings

	def next_expenditure
		((next_occurrence - last_occurrence) / frequency) * expenditure_for_frequency
	end

	def frequency
		tm = taggings.map { |t| t.transaction.transaction_date }.sort
		b = []
		i = 1
		while i < tm.count
			b << (tm[i] - tm[i-1])
			i = i + 1
		end
		b = b.sort.slice(1, b.count - 2) if b.count > 2
		f = b.sum / b.count rescue (1.day.to_i * 365)
		f
	end

	def first_occurrence
		taggings.map { |t| t.transaction.transaction_date }.sort.first
	end

	def last_occurrence
		taggings.map { |t| t.transaction.transaction_date }.sort.last
	end

	def next_occurrence
		tm = taggings.map { |t| t.transaction.transaction_date}.sort
		l = tm.first
		n = l + frequency
		while n < DateTime.now
			n = n + frequency
		end
		n
	end
		
	def expenditure_for_frequency
		expenditure_for_period(1.day.to_i * 365 / frequency)
	end

	def expenditure
		expenditure_for_period(12)
	end

	def expenditure_for_period(p)
		f = first_occurrence
		l = last_occurrence
		e = taggings.sum(:amount) / (((l - f)/1.day.to_i)+1) * 365/p
		e
	end

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
