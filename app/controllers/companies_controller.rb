class CompaniesController < ApplicationController

	def index
		require_perm!(current_user.can?(:index, Company)) || return
		@companies = Company.all.select { |c| current_user.can?(:show, c) }
	end

	def new
		require_perm!(current_user.can?(:create, Company)) || return
		@company = Company.new
	end

	def create
		require_perm!(current_user.can?(:create, Company)) || return
		@company = Company.new(params[:company])
		@company.name = 'UNNAMED' unless !@company.name.blank?
		if @company.save
			flash[:notice] = "Company '#{@company.name}' created."
			User.all.each do |u|
				u.touch
			end
			redirect_to_last_page
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

	def update
		@company = Company.find(params[:id]) rescue nil
		require_perm!(current_user.can?(:edit, @company)) || return
		if params[:company][:name] && params[:company][:name].blank?
			if @company.users.count == 0
				@company.destroy
			else
				respond_with_bip(@company)
			end
			redirect_to_last_page
			return
		end
		if @company
			respond_to do |format|
				if @company.update_attributes(params[:company])
					format.html { redirect_to(@company, :notice => "company '#{@company.name}' updated.") }
					format.json { respond_with_bip(@company) }
				else
					format.html { }
					format.json { respond_with_bip(@company) }
				end
			end
		end
	end
end
