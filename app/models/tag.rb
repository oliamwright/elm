class Tag < ActiveRecord::Base
	belongs_to :account
	has_many :taggings
	has_many :transactions, :through => :taggings

	def balance
		Tagging.where(:tag_id => self.id).sum(:amount).round(2)
	end
end
