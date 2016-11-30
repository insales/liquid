module Liquid
  # {% layout 'smth' %} sets context.layout = smth
  #
  #
  class Tag::Layout < Tag
    SYNTAX_HELP = "Syntax Error in 'layout' - Valid syntax: layout value"

    def initialize(tag_name, markup, parse_context)
      # same as #blank? in Rails
      raise SyntaxError.new(SYNTAX_HELP) unless markup =~ /[^[:space:]]/
      @name = Variable.new(markup, parse_context)
      super
    end

    def render(context)
      context.layout = @name.render context
      ''
    end
  end

  class Context
    attr_accessor :layout
  end

  Template.register_tag 'layout', Tag::Layout
end
