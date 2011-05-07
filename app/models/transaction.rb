class Transaction < ActiveRecord::Base
  belongs_to :account
	has_many :taggings, :dependent => :destroy
	has_many :tags, :through => :taggings

	before_save :fix_cash_amount

	scope :has_tag, lambda { |tag|
		joins(:taggings, :tags).where("tags.name = ?", tag)
	}

	def fix_cash_amount
		cash_tagging = self.taggings.select { |t| t.tag.name == "cash" }.first
		if cash_tagging
			if cash_tagging.amount < 0 and cash_tagging.amount == self.amount
				self.amount = 0
			end
		end
	end

	def self.with_tags(the_tags)
		Transaction.has_tag(the_tags.first).select { |t| t.has_all_tags(the_tags) }
	end

	def has_all_tags(the_tags)
		the_tags.each do |t|
			if !tags.include? Tag.find_by_name(t)
				return false
			end
		end
		true
	end

	def real_amount
		if self.amount == 0
			self.taggings.select { |t| t.tag.name == "cash" }.first.amount
		else
			self.amount
		end
	end

	def short_date
		transaction_date.strftime '%Y.%m.%d'
	end

	def type
		if amount > 0
			"income"
		elsif amount < 0
			"expense"
		else
			"cash"
		end
	end

	def type_for_tag(tag)
		if self.taggings.find_by_tag_id(tag.id).amount >= 0
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
