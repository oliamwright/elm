class TransactionsController < ApplicationController
	before_filter :load_account, :only => [ :index, :create, :destroy, :edit, :update ]

	def index

		@transactions = @account.transactions.order("transaction_date desc, id desc").paginate :page => params[:page], :per_page => 25

		@trans_chart = HighChart.new do |f|
			f.options[:legend] = { :enabled => false }
			f.options[:title][:text] = "Daily Totals & Balances"
			f.options[:x_axis] = { :categories => @transactions.reverse.group_by(&:transaction_date).map { |k,v| k.to_date } }
			f.options[:y_axis] = { :title => { :text => "$" } }
			f.series(
				:name => "Balance",
				:data => @transactions.reverse.group_by(&:transaction_date).map { |k,v| @account.balance_on(k) }
				#:type => 'line'
			)
			f.series(
				:name => "Expense",
				:data => @transactions.reverse.group_by(&:transaction_date).map { |k,v| v.select { |t| t.amount < 0 }.sum(&:amount) },
				:type => 'column'
			)
			f.series(
				:name => "Income",
				:data => @transactions.reverse.group_by(&:transaction_date).map { |k,v| v.select { |t| t.amount >= 0 }.sum(&:amount) },
				:type => 'column'
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

	private

end
