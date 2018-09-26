module Liquid
  # {% layout 'smth' %} sets context.layout = smth
  #
  #
  class Tag::Layout < Tag
    SYNTAX      = /(.*)/
    SYNTAX_HELP = "Syntax Error in 'layout' - Valid syntax: layout value"

    def initialize(tag_name, markup, tokens)
      raise SyntaxError.new(SYNTAX_HELP) unless markup =~ SYNTAX
      @name = Variable.new $1
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
