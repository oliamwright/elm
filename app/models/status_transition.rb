class StatusTransition < ActiveRecord::Base
  belongs_to :sub_item
  belongs_to :user
end
