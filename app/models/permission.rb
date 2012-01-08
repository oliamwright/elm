class Permission < ActiveRecord::Base
	has_and_belongs_to_many :roles

	def detail_string
		self.long_description
	end
end
