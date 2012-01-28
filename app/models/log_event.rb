class LogEvent < ActiveRecord::Base
  belongs_to :story
  belongs_to :sub_item
  belongs_to :user
	belongs_to :project

	before_save :convert_hash_data_to_yaml
	after_initialize :load_yaml_data

	attr_accessor :data

	def detail_string
		"#{self.ts_string} #{self.user.full_name} performed an unknown action"
	end

	def ts_string
		self.created_at.strftime("<span class='timestamp'>[%Y.%m.%d %H:%M]</span>")
	end

	def data
		unless @data
			@data = YAML.load(self.yaml_data) rescue {}
			unless @data
				@data = {}
			end
		end
		@data
	end

	private

	def load_yaml_data
		@data = YAML.load(self.yaml_data) rescue {}
		unless @data
			@data = {}
		end
	end

	def convert_hash_data_to_yaml
		self.yaml_data = @data.to_yaml
	end
end
