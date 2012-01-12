class Company < ActiveRecord::Base
	
	include CompanyCan
	include CompanyPermissions

	has_many :users

end
