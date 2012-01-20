class SubItem < ActiveRecord::Base

	include SubItemCan
	include SubItemPermissions

  belongs_to :story
	belongs_to :owner, :class_name => 'User'

	scope :bugs, where("item_type = 'bug'")
	scope :tasks, where("item_type = 'task'")

	before_create :number_item

	DEFAULT_ITEM_TYPE = 'task'

	INITIAL_STATUS = :open

	STATUS_MAP = {
		:open => [ :approved, :waiting, :ignored ],
		:approved => [ :waiting, :in_progress, :ignored ],
		:waiting => [ :in_progress, :ignored ],
		:in_progress => [ :completed, :ignored ],
		:completed => [ :ignored, :rolled ],
		:rolled => [],
		:ignored => [ :open ]
	}

	STATUSES = STATUS_MAP.keys

	def display_number
		if self.story
			"#{self.story.display_number}.#{self.number}"
		else
			"#{self.number}"
		end
	end

	def display_status
		self.status.to_s.titleize rescue "unknown"
	end

	private

	def number_item
		if self.story
			self.number = self.story.last_item_number + 1
		else
			self.number = 0
		end
	end

end
