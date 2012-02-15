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

Role.blueprint(:debug) do
	name { "Debug" }
end

User.blueprint do
	email { "user-#{sn}@test.com" }
	password { "password" }
end
