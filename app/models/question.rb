class Question < ActiveRecord::Base
  belongs_to :user
	belongs_to :questionable, :polymorphic => true
	has_many :answers
end
