class SubItem < ActiveRecord::Base

	STATUSES = [
		:open,
		:approved,
		:waiting,
		:in_progress,
		:completed,
		:dev,
		:rejected,
		:tested,
		:stage,
		:prod,
		:ignored
	]

	include SubItemCan
	include SubItemPermissions

  belongs_to :story
	belongs_to :owner, :class_name => 'User'
	has_many :task_ownerships, :dependent => :destroy
	has_many :users, :through => :task_ownerships
	has_many :log_events, :dependent => :destroy
	has_many :questions, :as => :questionable, :dependent => :destroy

	scope :bugs, where("item_type = 'bug'")
	scope :tasks, where("item_type = 'task'")

	before_create :number_item

	DEFAULT_ITEM_TYPE = 'task'

	INITIAL_STATUS = :open

	def complete?
		["completed", "dev", "tested", "stage", "prod"].include?(self.status)
	end

	def set_status!(to_status, user)
		from_status = self.status
		return if from_status.to_s == to_status.to_s
		self.status = to_status
		if self.save
			st = StatusTransitionEvent.new.init(user, self, from_status, to_status)
			st.save
		end
	end

	def display_estimated_time
		"%0.02f" % self.estimated_time
	end

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
