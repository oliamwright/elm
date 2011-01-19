class Transaction < ActiveRecord::Base
  belongs_to :account
	has_many :taggings, :dependent => :destroy
	has_many :tags, :through => :taggings

	def short_date
		transaction_date.strftime '%Y.%m.%d'
	end

	def type
		if amount >= 0
			"income"
		else
			"expense"
		end
	end

	def tag_string
		tags.collect { |t| t.name }.join(", ")
	end

	def parse_tag_string(tstr)
		logger.info "parsing tag string [#{tstr}]"
		taggings = Array.new
		tstr.strip!
		tag_names = tstr.split(/,/)
		tag_names.each do |tag_name|
			logger.info "found tag name [#{tag_name}]"
			tag_name.strip!
			fields = tag_name.split(/:/)
			amt = self.amount
			if fields.size == 2
				logger.info "found [#{fields[0]}] with amount [#{fields[1]}]"
				amt = fields[1]
				tag_name = fields[0]
			else
				logger.info "found [#{fields[0]}] with no amount, using [#{self.amount}]"
			end
			tag = Tag.where(:account_id => self.account.id, :name => tag_name).first
			if tag.nil?
				logger.info "couldn't find tag [#{tag_name}]... creating."
				tag = Tag.new(:account_id => self.account.id, :name => tag_name)
				tag.save
			else
				logger.info "found tag [#{tag.name}] <#{tag.id}>"
			end
			tagging = Tagging.new
			tagging.tag = tag
			tagging.transaction = self
			tagging.amount = amt
			taggings << tagging
		end
		return taggings
	end
end
