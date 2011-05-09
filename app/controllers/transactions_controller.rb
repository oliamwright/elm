class TransactionsController < ApplicationController
	before_filter :load_account, :only => [ :index, :create, :destroy, :edit, :update, :with_tags ]

	def index

		if params[:show] && params[:show] == 'all'
			@paginate = false
			@transactions = @account.transactions.order("transaction_date desc, id desc")
		else
			@paginate = false
			#@transactions = @account.transactions.order("transaction_date desc, id desc").paginate :page => params[:page], :per_page => 25
			@relevant_date = Date.today
			@transactions = @account.transactions.order("transaction_date desc, id desc").select { |t| t.transaction_date >= (@relevant_date - 1.month).beginning_of_month and t.transaction_date <= @relevant_date.end_of_month}
			@last_month = @account.transactions.order("transaction_date desc, id desc").select { |t| t.transaction_date >= (@relevant_date - 2.month).beginning_of_month and t.transaction_date <= (@relevant_date - 1.month).end_of_month }
		end

		@trans_chart = HighChart.new do |f|
			f.options[:legend] = { :enabled => true }
			f.options[:title][:text] = "Daily Totals & Balances"
			f.options[:x_axis] = { :type => :datetime }
			f.options[:y_axis] = { :title => { :text => "$" } }
			f.series(
				:name => "Balance",
				:data => @transactions.map { |t| [t.transaction_date.utc.to_i * 1000, t.account.balance_on(t.transaction_date)] }
				#:type => 'line'
			)
			f.series(
				:name => "Last Month",
				:data => @last_month.map { |t| [(t.transaction_date + 1.month).utc.to_i * 1000, t.account.balance_on(t.transaction_date)] },
				:type => 'line',
				:visible => false
			) unless params[:show] == "all"
			f.series(
				:name => "Cash Balance",
				:data => @transactions.map { |t| [t.transaction_date.utc.to_i * 1000, t.account.cash_balance_on(t.transaction_date)] }
			)
			f.series(
				:name => "Expense",
				:data => @transactions.select { |t| t.amount < 0 }.map {|t| [t.transaction_date.utc.to_i * 1000, t.amount] },
				:type => 'column',
				:visible => false
			)
			f.series(
				:name => "Income",
				:data => @transactions.select { |t| t.amount >= 0}.map {|t| [t.transaction_date.utc.to_i * 1000, t.amount] },
				:type => 'column',
				:visible => false
			)
		end
	end

	def new
		@transaction = Transaction.new
		@transaction.transaction_date = DateTime.now
	end

	def create
		tag_string = params[:transaction].delete(:tag_string)
		@transaction = Transaction.new(params[:transaction])
		@transaction.account = @account
		@taggings = @transaction.parse_tag_string(tag_string)
		@transaction.taggings = @taggings
		if @transaction.save
			flash[:notice] = "Transaction saved."
		else
			flash[:error] = "Could not save transaction."
		end
		redirect_to transactions_url
	end

	def edit
		@transaction = @account.transactions.find(params[:id])
	end

	def update
		@transaction = @account.transactions.find(params[:id])
		tag_str = params[:transaction].delete(:tag_string)
		@taggings = @transaction.parse_tag_string(tag_str)
		if @transaction.update_attributes(params[:transaction])
			@transaction.tags.each do |tag|
				if tag.transactions.count == 1 && !@taggings.map{|t| t.tag }.include?(tag)
					tag.destroy
				end
			end
			@transaction.taggings = @taggings
			flash[:notice] = "Transaction updated."
		else
			flash[:error] = "Could not update transaction."
		end
		redirect_to transactions_url
	end

	def destroy
		@transaction = @account.transactions.find(params[:id])
		@transaction.tags.each do |tag|
			if tag.transactions.count == 1
				tag.destroy
			end
		end
		if @transaction.destroy
			flash[:notice] = "Transaction destroyed."
		else
			flash[:error] = "Could not destroy transaction."
		end
		redirect_to transactions_url
	end

	def with_tags
		@tags = decode_with_tags(params[:tags])
		@transactions = Transaction.with_tags(@tags)

		respond_to do |format|
			format.html
			format.js { render :layout => nil }
		end
	end

	private

	def decode_with_tags(tags)
		if tags.class == Array
			tags
		elsif tags.class == String
			CGI.unescape(tags).split(/--/)
		else
			[]
		end
	end

end
