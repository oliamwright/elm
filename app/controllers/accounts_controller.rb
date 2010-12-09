class AccountsController < ApplicationController
	def index
		@accounts = Account.for_user(current_user)
	end
end
