module Liquid
  # Within the context of a layout, yield identifies a section where content
  # from the view should be inserted.
  # The simplest way to use this is to have a single yield, into which the
  # entire contents of the view currently being rendered is inserted.
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
  class Tag::Yield < Tag
    SYNTAX      = /(.*)/
    SYNTAX_HELP = "Syntax Error in 'yield' - Valid syntax: yield ['name']"
    # This is key that will be used if you haven't specified one
    EMPTY_YIELD_KEY = '_rendered_template_'

    def initialize(tag_name, markup, parse_context)
      raise SyntaxError.new(SYNTAX_HELP) unless markup =~ SYNTAX
      @what = !markup.empty? && Variable.new(markup, parse_context)
      super
    end

    def render(context)
      key = @what && @what.render(context)
      key = EMPTY_YIELD_KEY if !key || key.empty?
      res = context.content_for[key]
      if !res || res.empty?
        ''
      elsif res.is_a?(Array)
        res = res.first
      end
      res
    end
  end

  Template.register_tag 'yield', Tag::Yield
end
