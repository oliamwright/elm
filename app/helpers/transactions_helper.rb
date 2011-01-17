module TransactionsHelper
	def tag_string_with_links(trans)
		trans.taggings.collect { |t| link_to "#{t.tag.name}", t.tag }.join(", ")
	end
end
