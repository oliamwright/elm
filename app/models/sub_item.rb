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

  belongs_to :story, :touch => true
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

	searchable do
		integer :id

		text :description
		text :item_number do
			display_number
		end

		integer :number
		integer :owner_id
		integer :story_id
		integer :sprint_id do
			story.sprint ? story.sprint.id : 0
		end
		integer :project_id do
			story.project.id
		end

	end

	def ignored?
		["ignored"].include?(self.status)
	end

	def complete?
		["completed", "dev", "tested", "stage", "prod"].include?(self.status)
	end

	def display_created_at_date
		self.created_at.strftime("%Y.%m.%d")
	end

	def display_created_at_time
		self.created_at.strftime("%H:%M:%S")
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

	def actual_time
		self.task_ownerships.sum(:actual_time)
	end

	def display_actual_time
		"%0.02f" % self.actual_time
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

	def sort_number
		t = 0
		self.display_number.split(/\./).each_with_index do |p, idx|
			t += p.to_i * (1000 ** (3 - idx))
		end
		t
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
