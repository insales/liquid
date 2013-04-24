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
    EMPTY_YIELD_KEY = '_rendered_template_'

    def initialize(tag_name, markup, tokens)
      raise SyntaxError.new(SYNTAX_HELP) unless markup =~ SYNTAX
      @what = Variable.new $1
      super
    end

    def render(context)
      key = @what.render context
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
