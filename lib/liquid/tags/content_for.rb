module Liquid
  # The content_for method allows you to insert content into a yield block in your layout.
  # You only use content_for to insert content in named yields.
  #
  # It saves rendered text between tags into context's _content_for_ field,
  # which is a hash.
  #
  # You need explicitly set _context.content_for[Liquid::Tag::Yield::EMPTY_YIELD_KEY]_
  # to rendered string. There is shortcut _context.content_for_layout=_
  # that sets it and _context['content_for_layout_']_.
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
  class Tag::ContentFor < Block
    SYNTAX      = /([\S]+)/
    SYNTAX_HELP = "Syntax Error in tag 'content_for' - Valid syntax: content_for 'name'"

    def initialize(tag_name, markup, parse_context)
      # same as #blank? in Rails
      raise SyntaxError.new(SYNTAX_HELP) unless markup =~ /[^[:space:]]/
      @name = Variable.new(markup, parse_context)
      super
    end

    def render(context)
      result = super
      key = @name.render context
      context.content_for[key] = result
      ''
    end

    def block_delimiter
      "end_#{block_name}"
    end

    def blank?
      true
    end
  end

  class Context
    def content_for
      @content_for ||= {}
    end

    def content_for_layout=(value)
      content_for[Liquid::Tag::Yield::EMPTY_YIELD_KEY] =
        self['content_for_layout'] = value
    end
  end

  Template.register_tag 'content_for', Tag::ContentFor
end
