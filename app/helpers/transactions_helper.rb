module TransactionsHelper
	def tag_string_with_links(trans)
		trans.taggings.collect { |t| link_to "#{t.tag.name}", t.tag }.join(", ")
	end

	def encode_with_tags(tags)
		if tags.class == String
			tags
		elsif tags.class == Array
			tags.join('--')
		else
			""
		end
	end
end
