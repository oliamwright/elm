class TagsController < ApplicationController
	before_filter :load_account, :only => [:index, :show]

	def index
		@tags = @account.tags.order("name asc").paginate :page => params[:page], :per_page => 25
	end

	def show
		@tag = @account.tags.find(params[:id])
		@transactions = @tag.transactions.order("transaction_date asc, id asc").paginate :page => params[:page], :per_page => 25
		@trans_chart = HighChart.new do |f|
			f.options[:legend] = { :enabled => false }
			f.options[:title][:text] = "Daily Totals & Balances"
			f.options[:x_axis] = { :categories => @transactions.group_by(&:transaction_date).map { |k,v| k.to_date } }
			f.options[:y_axis] = { :title => { :text => "$" } }
			f.series(
				:name => "Balance",
				:data => @transactions.group_by(&:transaction_date).map { |k,v| @tag.balance_on(k) }
				#:type => 'line'
			)
			f.series(
				:name => "Expense",
				:data => @transactions.group_by(&:transaction_date).map { |k,v| v.select { |t| t.amount < 0 }.sum(&:amount) },
				:type => 'column'
			)
			f.series(
				:name => "Income",
				:data => @transactions.group_by(&:transaction_date).map { |k,v| v.select { |t| t.amount >= 0 }.sum(&:amount) },
				:type => 'column'
			)
		end
	end
end
