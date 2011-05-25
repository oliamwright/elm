class Event < ActiveRecord::Base
	belongs_to :debt
	belongs_to :event_object, :polymorphic => true, :dependent => :destroy
end
