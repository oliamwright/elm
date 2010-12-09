class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :authenticate_user!, :except => [ :home ]

	def home
	end

	private

	def load_account
		if params[:account_id]
			@account = Account.for_user(current_user).find(params[:account_id])
		elsif session[:account_id]
			@account = Account.for_user(current_user).find(session[:account_id])
		else
			@account = Account.for_user(current_user).first
		end
		session[:account_id] = @account.id
	end

end
