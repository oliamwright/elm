class Tagging < ActiveRecord::Base
	belongs_to :transaction
	belongs_to :tag
end
