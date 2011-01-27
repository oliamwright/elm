class Tagging < ActiveRecord::Base
	belongs_to :transaction
	belongs_to :tag

	def first_tagging?
		self.transaction.taggings.first == self
	end

	def only_tagging?
		self.transaction.taggings.count == 1
	end
end
