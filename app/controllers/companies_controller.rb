class CompaniesController < ApplicationController

	def index
		@companies = Company.all.select { |c| current_user.can?(:show, c) }
	end

	def new
		@company = Company.new
	end

	def create
		@company = Company.new(params[:company])
		if @company.save
			flash[:notice] = "Company '#{@company.name}' created."
			redirect_to companies_url
			return
		else
			flash[:error] = "Company '#{@company.name}' could not be created."
			render :action => :new
		end
	end

	def show
		@company = Company.find(params[:id]) rescue nil
		require_perm!(current_user.can?(:show, @company)) || return
	end

end
