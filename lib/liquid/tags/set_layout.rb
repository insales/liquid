module Liquid
  # {% set_layout 'smth' %} sets context.layout = smth
  #
  #
  class SetLayout < Tag
    SYNTAX      = /(#{QuotedString}+){0,1}/
    SYNTAX_HELP = "Syntax Error in 'set_layout' - Valid syntax: set_layout 'name'"

    def initialize(tag_name, markup, tokens)
      raise SyntaxError.new(SYNTAX_HELP) unless markup =~ SYNTAX
      @name = $1
      super
    end

    def render(context)
      context.layout = context[@name]
      ''
    end
  end

  class Context
    attr_accessor :layout
  end

  Template.register_tag 'set_layout', SetLayout
end
