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
end
