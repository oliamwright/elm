module SemanticTableHelper
  class SemanticTable

    def initialize(template, object = nil)
      @template = template
      @object = object
    end

    def header(*arr, &block)
      content = capture(&block) if block_given?
      if arr.size != 0
        content = arr.collect { |a|
          if a.is_a?(Symbol)
            @template.sortable(a.to_s).html_safe
          else
            @template.content_tag(:th, a)
          end
        }.join
      end
      content = @template.content_tag(:tr, content.html_safe, :class => 'header_row')
			@template.content_tag(:thead, content.html_safe)
    end

		def classed_data(tag_class, *arr, &block)
      return @template.content_tag(:td, capture(&block), :class => tag_class) if block_given?
      data = arr.to_a
      data = arr[0] if arr.size <= 1
      content = ''
      if data.is_a?(Array)
        content = data.collect { |a|
          data(a)
        }.join
      else
        value = data
        if data.is_a?(Symbol)
          if @obj.respond_to?(data)
            value = @obj.send(data)
          end
        end
        content = @template.content_tag(:td, value.to_s, :class => tag_class)
      end
      return content.html_safe
    end

    def data(*arr, &block)
      return @template.content_tag(:td, capture(&block)) if block_given?
      data = arr.to_a
      data = arr[0] if arr.size <= 1
      content = ''
      if data.is_a?(Array)
        content = data.collect { |a|
          data(a)
        }.join
      else
        value = data
        if data.is_a?(Symbol)
          if @obj.respond_to?(data)
            value = @obj.send(data)
          end
        end
        content = @template.content_tag(:td, value.to_s)
      end
      return content.html_safe
    end

    def row(data = nil, &block)
      content = @template.capture(&block) if block_given?
      content = data unless data.nil? || data.empty?
      @template.content_tag(:tr, content)
    end

    # args
    #   :label - text to use for the label
    def value(name, args = {})
      raise ArgumentError, "Object not set for table, try using semantic_table_for(object)" unless @object
      value = name
      if name
        raise ArgumentError, "Object does not respond to #{name}" unless @object.respond_to?(name)
        value = @object.send(name)
      end
      data_label = @template.content_tag(:td, args[:label] || name.to_s.titleize, :class => "data_label #{name.to_s}")
      data_value = @template.content_tag(:td, value, :class => "data_value #{name.to_s}")
      @template.content_tag(:tr, data_label + data_value)
    end

		def summary(&block)
			@template.concat("<tr class='summary'>".html_safe)
			yield(@object)
			@template.concat("</tr>".html_safe)
			return
		end

    def summary_data(*arr, &block)
      return @template.content_tag(:td, capture(&block)) if block_given?
      data = arr.to_a
      data = arr[0] if arr.size <= 1
      content = ''
      if data.is_a?(Array)
        content = data.collect { |a|
          summary_data(a)
        }.join
      else
        value = data
        if data.is_a?(Symbol)
					if data == :empty
						value = ''
          elsif @obj.respond_to?(data)
            value = @obj.send(data)
          end
        end
        content = @template.content_tag(:td, value.to_s)
      end
      return content.html_safe
    end

    def classed_summary_data(tag_class, *arr, &block)
      return @template.content_tag(:td, capture(&block), :class => tag_class) if block_given?
      data = arr.to_a
      data = arr[0] if arr.size <= 1
      content = ''
      if data.is_a?(Array)
        content = data.collect { |a|
          summary_data(a)
        }.join
      else
        value = data
        if data.is_a?(Symbol)
					if data == :empty
						value = ''
          elsif @obj.respond_to?(data)
            value = @obj.send(data)
          end
        end
        content = @template.content_tag(:td, value.to_s, :class => tag_class)
      end
      return content.html_safe
    end

    def rows(sym = nil, &block)
      @object.each_with_index do |obj, idx|
				if sym.nil?
					if obj.respond_to? :row_class
						extra_class = obj.send(:row_class) rescue ''
					else
						extra_class = ''
					end
				else
					extra_class = obj.send(sym) rescue ''
				end
				extra_class += idx % 2 == 0 ? ' even_row' : ' odd_row'
        @template.concat("<tr class='data_row #{extra_class}'>".html_safe)
        @obj = obj
        yield(obj)
        @template.concat("</tr>".html_safe)
      end
      return
    end

    def links(&block)
      @template.content_tag(:td, @template.capture(&block), :class => 'content_links')
    end

    def each(objects = nil, &block)
      objects = @object unless objects
      objects.each do |o|
        @object = o;
        @obj = o
        yield
      end
      @object = objects
      return
    end

    def obj
      @obj
    end
  end

  def semantic_table(&block)
    obj = SemanticTable.new(self)
    concat("<table class='new_content_table'>".html_safe)
    yield(obj)
    concat("</table>".html_safe)
    return
  end

  # args
  #   :class - css class to use for the table tag
  def semantic_table_for(object, args = {}, &block)
    css_class = args[:class] || 'content_table'
    obj = SemanticTable.new(self, object)
    concat("<table class='#{css_class}'>".html_safe)
    yield(obj)
    concat("</table>".html_safe)
    return
  end

  def semantic_data_table_for(object, &block)
    semantic_table_for(object, {:class => 'data_table'}, &block)
  end

end
