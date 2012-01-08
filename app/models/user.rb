class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_many :role_memberships
	has_many :roles, :through => :role_memberships

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

	attr_accessor :current_project

	after_save :assert_guid!

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
			return has_permission?(object.class.to_s.underscore.to_sym, action.to_sym)
		else
			return ret
		end
	end

	def class_permission?(project = current_project, scope, perm)
		puts " * User(#{self.id}).class_permission?(#{project.id rescue nil}, #{scope}, #{perm})"
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

end
