class TransactionsController < ApplicationController
	before_filter :load_account, :only => [ :index, :create ]

	def index
		@transactions = @account.transactions.paginate :page => params[:page], :per_page => 25
	end

	def new
		@transaction = Transaction.new
		@transaction.transaction_date = DateTime.now
	end

	def create
		@transaction = Transaction.new(params[:transaction])
		@transaction.account = @account
		if @transaction.save
			flash[:notice] = "Transaction saved."
		else
			flash[:error] = "Could not save transaction."
		end
		redirect_to transactions_url
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
