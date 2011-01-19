class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :authenticate_user!, :except => [ :home ]
	before_filter :get_version

	def home
	end

	private

	def get_version
		@VERSION = %x[cd #{RAILS_ROOT} && cat VERSION]
		if @VERSION.nil?
			@VERSION = "none"
		end
		@VERSION.chomp!
		if RAILS_ENV == "development"
			@VERSION += " [dev]"
		end
		if RAILS_ENV == "test"
			@VERSION += " [test]"
		end
	end

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
