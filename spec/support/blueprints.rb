require 'machinist/active_record'

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end

Company.blueprint do
	name { "Company #{sn}" }
end

Role.blueprint do
	name { "Role #{sn}" }
end

Role.blueprint(:admin) do
	name { "Admin" }
end

Role.blueprint(:project_team) do
	name { "Project Team" }
end

Role.blueprint(:client_team) do
	name { "Client Team" }
end

Role.blueprint(:anyone) do
	name { "Anyone" }
end

Role.blueprint(:project_owner) do
	name { "Project Owner" }
end

Role.blueprint(:project_manager) do
	name { "Project Manager" }
end

Role.blueprint(:debug) do
	name { "Debug" }
end

User.blueprint do
	Role.make!(:anyone) unless Role.Anyone
	Role.make!(:admin) unless Role.Admin
	Role.make!(:project_owner) unless Role.ProjectOwner
	Role.make!(:client_team) unless Role.ClientTeam
	Role.make!(:project_team) unless Role.ProjectTeam
	email { "user-#{sn}@test.com" }
	password { "password" }
end

Project.blueprint do
	owner { User.make! }
end

Sprint.blueprint do
	project { Project.make! }
end

AdditionalTimeItem.blueprint do
  # Attributes here
end

Phase.blueprint do
  # Attributes here
end
