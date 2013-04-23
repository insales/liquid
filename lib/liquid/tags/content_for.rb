module Liquid
  # The content_for method allows you to insert content into a yield block in your layout. 
  # You only use content_for to insert content in named yields. 
  # 
  # It saves rendered text between tags into context's _content_for_ field,
  # which is a hash.
  #
  # You need explicitly set _context.content_for[Liquid::Yield::EMPTY_YIELD_KEY]_
  # to rendered string.
  #
  # In your layout:
  #  <title>{% yield 'title' %}</title>
  #  <body>{% yield %}</body>
  #
  # In the view:
  #  {% content_for 'title' %} The title {% end_content_for %}
  #  The body    
  #
  #
  # Will produce:
  #  <title>The title</title>
  #  <body>The body</body>
  #
  #
  class ContentFor < Block
    SYNTAX      = /(#{QuotedString}+)/
    SYNTAX_HELP = "Syntax Error in tag 'content_for' - Valid syntax: content_for 'name'"

    def initialize(tag_name, markup, tokens)
      raise SyntaxError.new(SYNTAX_HELP) unless markup =~ SYNTAX
      @name = $1
      super
    end

    def render(context)
      result = ''
      context.stack { result = render_all @nodelist, context }
      context.content_for[context[@name]] = result
      ''
    end

    def block_delimiter
      "end_#{block_name}"
    end
  end

  class Context
    def content_for
      @content_for ||= {}
    end
  end

  Template.register_tag 'content_for', ContentFor
end
