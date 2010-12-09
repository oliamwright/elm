module TransactionsHelper
	def tag_string_with_links(trans)
		trans.tags.collect { |t| link_to t.name, t }.join(", ")
	end
end
