class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	include UserCan
	include UserPermissions

	has_many :role_memberships
	has_many :roles, :through => :role_memberships
	has_many :projects, :through => :role_memberships
	belongs_to :company

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :title, :phone, :company_id

	attr_accessor :current_project

	after_save :assert_guid!
	after_create :assign_anyone!
	after_create :assign_admin!

	def formatted_phone
		return "" unless self.phone
		"(#{self.phone[0,3]}) #{self.phone[3,3]}-#{self.phone[6,4]}"
	end

	def full_name_last_first
		"#{self.last_name}, #{self.first_name}"
	end

	def full_name
		"#{self.first_name} #{self.last_name}"
	end

	def company_name
		self.company.name rescue ""
	end

	def username
		self.email.sub(/@.*/, '')
	end

	def has_global_role?(role)
		if role.class == Integer
			role = Role.find(role)
		end
		self.roles.global.include?(role)
	end

	def has_project_role?(project, role)
		if role.class == Integer
			role = Role.find(role)
		end
		project = project.id rescue project
		self.roles.all_for_project(project).include?(role)
	end

	def can?(action, object)
		if object.nil?
			puts ""
			puts " * User(#{self.id}).can?(#{action}, nil)"
			return false
		end

		puts ""
		puts " * User(#{self.id}).can?(#{action}, #{object.class} / #{object.id rescue object})"

		# kill recursion for users and User class permissions
		if object.class == User || object == User
			unless self.respond_to?(:_can?)
				return false
			end
			ret = self._can?(action, object)
			puts " => #{ret}"
			return ret
		end

		# class-level permissions
		if object.class == Class
			scope = object.to_s.underscore.to_sym
			perm = action.to_sym
			return self.class_permission?(scope, perm)
		end

		unless object.respond_to?(:can?)
			puts " No permissions defined for #{object.class} / #{object.id rescue object}"
			puts " => false"
			return false
		end

		ret = object.can?(action, self)
		puts " => #{ret}"
		if ret == :default
			return class_permission?(object.class.to_s.underscore.to_sym, action.to_sym)
		else
			return ret
		end
	end

	def _can?(action, object)
		puts " * User(#{self.id})._can?(#{action}, #{object})"
		if object.class == Class
			scope = object.to_s.underscore.to_sym
		else
			scope = object.class.to_s.underscore.to_sym
		end
		perm = action.to_sym
		return class_permission?(scope, perm)
	end

	def class_permission?(scope, perm, project = current_project)
		puts " * User(#{self.id}).class_permission?(#{scope}, #{perm}, #{project.id rescue nil})"
		pid = (project.id rescue nil)
		p = Permission.find_by_scope_and_short_name(scope, perm)
		roles = self.roles.all_for_project(pid)
		roles.each do |role|
			perms = role.permissions
			perms.each do |permission|
				if p == permission
					ret = true
					puts " => #{ret} (#{role.name})"
					return ret
				end
			end
		end
		ret = false
		puts " => #{ret}"
		return ret
	end

	def assert_guid!
		unless self.guid
			self.update_attribute(:guid, UUID.generate) unless self.guid
		end
	end

	def assign_anyone!
		self.roles << Role.Anyone
	end

	def assign_admin!
		self.roles << Role.Admin if User.all.count == 1
	end

end
