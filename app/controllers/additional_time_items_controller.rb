class AdditionalTimeItemsController < ApplicationController

	def update
		@additional_time_item = AdditionalTimeItem.find(params[:id]) rescue nil
		if @additional_time_item
			respond_to do |format|
				if @additional_time_item.update_attributes(params[:additional_time_item])
					format.html { redirect_to(@additional_time_item) }
					format.json { respond_with_bip(@additional_time_item) }
				else
					format.html { }
					format.json { respond_with_bip(@additional_time_item) }
				end
			end
		end
	end

end
