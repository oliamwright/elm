class TransactionsController < ApplicationController
	before_filter :load_account, :only => [ :index, :create ]

	def index
		@transactions = @account.transactions.order("transaction_date, id desc").paginate :page => params[:page], :per_page => 25
	end

	def new
		@transaction = Transaction.new
		@transaction.transaction_date = DateTime.now
	end

	def create
		@tags = parse_tag_string(params[:transaction][:tag_string])
		params[:transaction].delete(:tag_string)
		@transaction = Transaction.new(params[:transaction])
		@transaction.tags << @tags
		@transaction.account = @account
		if @transaction.save
			flash[:notice] = "Transaction saved."
		else
			flash[:error] = "Could not save transaction."
		end
		redirect_to transactions_url
	end

	private

	def parse_tag_string(tstr)
		logger.info "parsing tag string [#{tstr}]"
		tags = Array.new
		tstr.strip!
		tag_names = tstr.split(/,/)
		tag_names.each do |tag_name|
			logger.info "found tag name [#{tag_name}]"
			tag_name.strip!
			tag = Tag.where(:account_id => @account.id, :name => tag_name).first
			if tag.nil?
				logger.info "couldn't find tag [#{tag_name}]... creating."
				tag = Tag.new(:account_id => @account.id, :name => tag_name)
				tag.save
			else
				logger.info "found tag [#{tag.name}] <#{tag.id}>"
			end
			tags << tag
		end
		return tags
	end
end
