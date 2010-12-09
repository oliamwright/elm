class AccountsController < ApplicationController
	def index
		@accounts = Account.for_user(current_user)
		#@accounts = Account.all
		@accounts = @accounts.paginate :page => params[:page], :per_page => 25
	end

	def new
		@account = Account.new
	end

	def create
		@account = Account.new(params[:account])
		@account.user = current_user
		if @account.save
			flash[:notice] = "Account '#{@account.name}' has been created."
		else
			flash[:error] = "Could not create account '#{@account.name}'."
		end
		redirect_to accounts_url
	end

end
