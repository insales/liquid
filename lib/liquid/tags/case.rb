module Liquid
  class Case < Block
    Syntax     = /(#{QuotedFragment})/o
    WhenSyntax = /(#{QuotedFragment})(?:(?:\s+or\s+|\s*\,\s*)(#{QuotedFragment}.*))?/om

    def initialize(tag_name, markup, options)
      super
      @blocks = []

      if markup =~ Syntax
        @left = Expression.parse($1)
      else
        raise SyntaxError.new("Syntax Error in tag 'case' - Valid syntax: case [condition]")
      end
    end

    def parse(tokens)
      body = BlockBody.new
      while parse_body(body, tokens)
        body = @blocks.last.attachment
      end
    end

    def nodelist
      @blocks.map(&:attachment)
    end

    def unknown_tag(tag, markup, tokens)
      case tag
      when 'when'.freeze
        record_when_condition(markup)
      when 'else'.freeze
        record_else_condition(markup)
      else
        super
      end
    end

    def render(context)
      context.stack do
        execute_else_block = true

        output = ''
        @blocks.each do |block|
          if block.else?
            return block.attachment.render(context) if execute_else_block
          elsif block.evaluate(context)
            execute_else_block = false
            output << block.attachment.render(context)
          end
        end
        output
      end
    end

    private

    def record_when_condition(markup)
      body = BlockBody.new

      while markup
        # Create a new nodelist and assign it to the new block
        if not markup =~ WhenSyntax
          raise SyntaxError.new("Syntax Error in tag 'case' - Valid when condition: {% when [condition] [or condition2...] %} ")
        end

        markup = $2

        block = Condition.new(@left, '=='.freeze, Expression.parse($1))
        block.attach(body)
        @blocks << block
      end
    end

    def record_else_condition(markup)
      if not markup.strip.empty?
        raise SyntaxError.new("Syntax Error in tag 'case' - Valid else condition: {% else %} (no parameters) ")
      end

      block = ElseCondition.new
      block.attach(BlockBody.new)
      @blocks << block
    end
  end

  Template.register_tag('case'.freeze, Case)
end
